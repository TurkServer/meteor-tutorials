# Yet another ugly hack to make the tutorial manager accessible to the template instance
# This is bad because data context is supposed to be read only
# FIXME: https://github.com/meteor/meteor/issues/2010
Template.tutorial.helpers
  tutorialManager: -> @tm = new TutorialManager(@)

Template.tutorial.rendered = ->
  # Set the template instance so we can access it from the helper below
  @data.tm.templateInstance = @
  tutorialManager = @data.tm

  $spot = @$(".spotlight")
  $modal = @$(".modal-dialog")

  # Add resizer on first render
  @resizer = ->
    [spotCSS, modalCSS] = tutorialManager.getPositions()
    # Don't animate, just move
    $spot.css(spotCSS)
    $modal.css(modalCSS)

  # attach a window resize handler
  $(window).on('resize', @resizer)

  # Make modal draggable so it can be moved out of the way if necessary
  $modal.drags
    handle: ".modal-footer"

  # jQuery UI code; currently not being used
  # Set an arbitrary scope so it can't be dropped on anything
#  $modal.draggable
#    scope: "tutorial-modal"
#    containment: "window"
#    handle: ".modal-footer" # Doesn't work without this on IE, apparently

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

    # Move things where they should go, after the template renders
    Meteor.defer =>
      # Animate spotlight and modal to appropriate positions
      $spot = @templateInstance.$(".spotlight")
      $modal = @templateInstance.$(".modal-dialog")

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
