defaultSpot =
  top: 0
  left: 0
  bottom: 0
  right: 0

defaultModal =
  top: "10%"
  left: "50%"
  width: 560
  "margin-left": -280

spotPadding = 10 # How much to expand the spotlight on all sides
modalBuffer = 20 # How much to separate the modal from the spotlight

class @Tutorial
  constructor: (@steps) ->
    @step = 0
    @stepDep = new Deps.Dependency

  prev: ->
    return if @step is 0
    @step--
    @stepDep.changed()

  next: ->
    return if @step is (@steps.length - 1)
    @step++
    @stepDep.changed()

  prevEnabled: ->
    @stepDep.depend()
    return @step > 0

  nextEnabled: ->
    @stepDep.depend()
    # TODO don't enable next for certain steps
    return @step < (@steps.length - 1)

  currentTemplate: ->
    @stepDep.depend()
    return @steps[@step].template

  # Stuff below is currently not reactive
  currentLoadFunc: ->
    return @steps[@step].onLoad

  getPositions: ->
    # @stepDep.depend() if we want reactivity
    selector = @steps[@step].spot
    return [ defaultSpot, defaultModal ] unless selector?

    items = $(selector)
    if items.length is 0
      console.log "Tutorial error: couldn't find spot for " + selector
      return [ defaultSpot, defaultModal ]

    # Compute spot and modal positions
    hull =
      top: 5000
      left: 5000
      bottom: 5000
      right: 5000

    items.each (i) ->
      $el = $(this)
      offset = $el.offset()
      hull.top = Math.min(hull.top, offset.top)
      hull.left = Math.min(hull.left, offset.left)
      # outer height/width used here: http://api.jquery.com/outerHeight/
      hull.bottom = Math.min(hull.bottom, $(window).height() - offset.top - $el.outerHeight())
      hull.right = Math.min(hull.right, $(window).width() - offset.left - $el.outerWidth())

    # enlarge spotlight slightly and find largest side
    maxKey = null
    maxVal = 0
    for k,v of hull
      if v > maxVal
        maxKey = k
        maxVal = v
      hull[k] = Math.max(0, v - spotPadding)

    # put modal on the side with the most space
    modal = null
    switch maxKey
      when "top" # go as close to top as possible
        modal = $.extend {}, defaultModal, { top: "5%" }
      when "bottom" # start from bottom of spot
        modal = $.extend {}, defaultModal,
          top: $(window).height() - hull.bottom + modalBuffer
      when "left"
        width = Math.min(hull.left - 2*modalBuffer, defaultModal.width)
        modal = $.extend {}, defaultModal,
          left: hull.left / 2
          width: width
          "margin-left": -width/2
      when "right"
        width = Math.min(hull.right - 2*modalBuffer, defaultModal.width)
        modal = $.extend {}, defaultModal,
          left: $(window).width() - hull.right / 2
          width: width
          "margin-left": -width/2

    return [ hull, modal ]
