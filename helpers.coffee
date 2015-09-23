Template.tutorial.helpers
  tutorialManager: -> Template.instance().tm = new TutorialManager(@)

Template.tutorial.rendered = ->
  $spot = @$(".spotlight")
  $modal = @$(".modal-dialog")

  # Add resizer on first render
  @resizer = =>
    [spotCSS, modalCSS] = @tm.getPositions()
    # Don't animate, just move
    $spot.css(spotCSS)
    $modal.css(modalCSS)

  # attach a window resize handler
  $(window).on('resize', @resizer)

  # Make modal draggable so it can be moved out of the way if necessary
  $modal.drags
    handle: ".modal-footer"

Template.tutorial.destroyed = ->
  # Take off the resize watcher
  $(window).off('resize', @resizer) if @resizer
  @resizer = null

Template.tutorial.helpers
  content: ->
    # Run load function, if any
    # Don't run it reactively in case it accesses reactive variables
    if (func = @currentLoadFunc())?
      Deps.nonreactive(func)

    tutorialInstance = Template.instance()

    # Move things where they should go, after the template renders
    Meteor.defer =>
      # Animate spotlight and modal to appropriate positions
      $spot = tutorialInstance.$(".spotlight")
      $modal = tutorialInstance.$(".modal-dialog")
      # Move things where they should go
      [spotCSS, modalCSS] = @getPositions()
      $spot.animate(spotCSS)
      $modal.animate(modalCSS)
      return

    # Template will render with tutorial as the data context
    # This function is reactive; the above will run whenever the context changes
    return @currentTemplate()

Template._tutorial_buttons.events =
  "click .action-tutorial-back": -> @prev()
  "click .action-tutorial-next": -> @next()
  "click .action-tutorial-finish": -> @finish()
