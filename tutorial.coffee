defaultSpot = ->
  top: 0
  left: 0
  bottom: $(window).height()
  right: $(window).width()

defaultModal = ->
  # ensure the modal still fits on small screens
  width = Math.min( $(window).width(), 560)
  return {
    top: "10%"
    left: "50%"
    width: width
    "margin-left": -width / 2 # keep the modal centered
  }

spotPadding = 10 # How much to expand the spotlight on all sides
modalBuffer = 20 # How much to separate the modal from the spotlight

_sessionKeyPrefix = "_tutorial_step_"

class @TutorialManager
  constructor: (options) ->
    check(options.steps, Array)

    @steps = options.steps
    @onFinish = options.onFinish || null
    @emitter = options.emitter

    # Grab existing step if it exists - but don't grab it reactively,
    # or this template will keep reloading
    if options.id?
      @sessionKey = _sessionKeyPrefix + options.id
      @step = Deps.nonreactive => Session.get(@sessionKey)

    @step ?= 0
    @stepDep = new Deps.Dependency
    @finishedDep = new Deps.Dependency

    # Build array of reactive dependencies for events
    return unless @emitter
    @buildActionDeps()

  buildActionDeps: ->
    self = @
    @actionDeps = []
    for i, step of @steps
      if step.require
        check(step.require.event, String)
        dep = new Deps.Dependency
        validator = step.require.validator
        check(validator, Function) if validator
        dep.completed = false
        @actionDeps.push(dep)

        # Bind a function to watch for this event
        checker = (->
          # Bind validator dep in closure
          val = validator
          d = dep
          autoContinue = step.require.autoContinue
          stepIndex = self.steps.indexOf step
          return ->
            actionCompleted = if val then val.apply(this, arguments) else true
            if actionCompleted
              if stepIndex == self.step && autoContinue
                self.next()
              d.completed = true
              d.changed()
        )()
        @emitter.on step.require.event, checker

      else
        @actionDeps.push(null)

  # Store steps in Session variable when they change
  prev: ->
    return if @step is 0
    @step--
    @stepDep.changed()
    Session.set(@sessionKey, @step) if @sessionKey?

  next: ->
    return if @step is (@steps.length - 1)
    @step++
    @stepDep.changed()
    Session.set(@sessionKey, @step) if @sessionKey?

  # Process finish click. If there is a function to call, only call it once.
  finish: ->
    if @onFinish?
      @finishedDep.finished = true
      @finishedDep.changed()
      @onFinish()

  prevEnabled: ->
    @stepDep.depend()
    return @step > 0

  nextEnabled: ->
    @stepDep.depend()
    return @step < (@steps.length - 1) and @stepCompleted()

  stepCompleted: ->
    @stepDep.depend()
    actionDep = @actionDeps?[@step]
    return true unless actionDep

    actionDep.depend()
    return actionDep.completed

  finishEnabled: ->
    @stepDep.depend()
    return @step is @steps.length - 1 and @stepCompleted()

  # Debounce for finish button
  finishPending: ->
    @finishedDep.depend()
    return @finishedDep.finished

  currentTemplate: ->
    @stepDep.depend()
    template = @steps[@step].template
    # Support both string and direct references.
    return if _.isString(template) then Template[template] else template

  # Stuff below is currently not reactive
  currentLoadFunc: ->
    return @steps[@step].onLoad

  getPositions: ->
    # @stepDep.depend() if we want reactivity
    selector = @steps[@step].spot
    return [ defaultSpot(), defaultModal() ] unless selector?

    items = $(selector)
    if items.length is 0
      console.log "Tutorial error: couldn't find spot for " + selector
      return [ defaultSpot(), defaultModal() ]

    # Compute spot and modal positions
    hull =
      top: 5000
      left: 5000
      bottom: 5000
      right: 5000

    items.each (i) ->
      $el = $(this)
      # outer height/width used here: http://api.jquery.com/outerHeight/
      # Second computation adds support for *SOME* SVG elements
      elWidth = $el.outerWidth() || parseInt($el.attr("width"))
      elHeight = $el.outerHeight() || parseInt($el.attr("height"))
      offset = $el.offset()

      hull.top = Math.min(hull.top, offset.top)
      hull.left = Math.min(hull.left, offset.left)
      hull.bottom = Math.min(hull.bottom, $(window).height() - offset.top - elHeight)
      hull.right = Math.min(hull.right, $(window).width() - offset.left - elWidth)

    # enlarge spotlight slightly and find largest side
    maxKey = null
    maxVal = 0
    for k,v of hull
      if v > maxVal
        maxKey = k
        maxVal = v
      hull[k] = Math.max(0, v - spotPadding)

    modalStyle = defaultModal()

    modal = switch
      # When the spotlight is very large, stick the modal in the center and let the user deal with it
      when maxVal < 200 then modalStyle
      # Otherwise put modal on the side with the most space
      when maxKey is "top" # go as close to top as possible
        $.extend {}, modalStyle, { top: "5%" }
      when maxKey is "bottom" # start from bottom of spot
        $.extend {}, modalStyle,
          top: $(window).height() - hull.bottom + modalBuffer
      when maxKey is "left"
        width = Math.min(hull.left - 2*modalBuffer, modalStyle.width)
        $.extend {}, modalStyle,
          left: hull.left / 2
          width: width
          "margin-left": -width/2
      when maxKey is "right"
        width = Math.min(hull.right - 2*modalBuffer, modalStyle.width)
        $.extend {}, modalStyle,
          left: $(window).width() - hull.right / 2
          width: width
          "margin-left": -width/2
    return [ hull, modal ]
