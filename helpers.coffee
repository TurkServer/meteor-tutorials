Handlebars.registerHelper "tutorial", (steps) ->
  new Handlebars.SafeString Template.tutorial(new Tutorial(steps))

Template.tutorial.rendered = ->
  # Animate spotlight and modal to appropriate positions
  spot = @find(".spotlight")
  modal = @find(".modal")
  tutorial = @data

  [spotCSS, modalCSS] = tutorial.getPositions()
  $(spot).animate(spotCSS)
  $(modal).animate(modalCSS)

  return if @initialRendered # Only do the below on first render
  console.log "first tutorial render"

  # attach a window resize handler
  @resizer = ->
    [spotCSS, modalCSS] = tutorial.getPositions()
    # Don't animate, just move
    $(spot).css(spotCSS)
    $(modal).css(modalCSS)

  $(window).on('resize', @resizer)

  # TODO add a dependency for jQuery UI
  # Make modal draggable so it can be moved out of the way if necessary
  # Set an arbitrary scope so it can't be dropped on anything
  $(modal)?.draggable
    scope: "tutorial-modal"
    containment: "window"

  @initialRendered = true

Template.tutorial.destroyed = ->
  # Take off the resize watcher
  $(window).off('resize', @resizer) if @resizer
  @resizer = null

Template.tutorial.content = ->
  # Run load function, if any
  @currentLoadFunc()?()

  @currentTemplate()()

Template.tutorial_buttons.events =
  "click .action-tutorial-back": -> @prev()
  "click .action-tutorial-next": -> @next()

Template.tutorial_buttons.prevDisabled = ->
  unless @prevEnabled() then "disabled" else ""
Template.tutorial_buttons.nextDisabled = ->
  unless @nextEnabled() then "disabled" else ""
