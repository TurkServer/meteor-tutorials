Handlebars.registerHelper "tutorial", (options) ->
  new Handlebars.SafeString Template._tutorial(new TutorialManager(options))

Template._tutorial.rendered = ->
  # Animate spotlight and modal to appropriate positions
  spot = @find(".spotlight")
  modal = @find(".modal")
  tutorial = @data

  # Move things where they should go
  [spotCSS, modalCSS] = tutorial.getPositions()
  $(spot).animate(spotCSS)
  $(modal).animate(modalCSS)

  return if @initialRendered

  # Only do this on first render
  @resizer = ->
    [spotCSS, modalCSS] = tutorial.getPositions()
    # Don't animate, just move
    $(spot).css(spotCSS)
    $(modal).css(modalCSS)

  # attach a window resize handler
  $(window).on('resize', @resizer)

  # Make modal draggable so it can be moved out of the way if necessary
  # Set an arbitrary scope so it can't be dropped on anything
  $(modal).draggable
    scope: "tutorial-modal"
    containment: "window"
    handle: ".modal-footer" # Doesn't work without this on IE, apparently

  @initialRendered = true

Template._tutorial.destroyed = ->
  # Take off the resize watcher
  $(window).off('resize', @resizer) if @resizer
  @resizer = null

Template._tutorial.content = ->
  # Run load function, if any
  @currentLoadFunc()?()
  # Pass tutorial to template so we can use actionRequired helper
  @currentTemplate()(@)

Template._tutorial_buttons.events =
  "click .action-tutorial-back": -> @prev()
  "click .action-tutorial-next": -> @next()
  "click .action-tutorial-finish": -> @onFinish?()
