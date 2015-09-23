## vNEXT

* Ensure that modal width is small enough for screens below 560px (e.g. mobile).
* Update documentation for Meteor 1.0+.

## v0.6.7

* Update versions for Meteor 1.2.
* Fix a potential race condition in loading the tutorial template. (#11)

## v0.6.6

* Use weak dependencies on Bootstrap packages for more flexibility.

## v0.6.5

* Switch to the official Bootstrap 3 package, `twbs:bootstrap`.

## v0.6.4

* Switch to a better supported bootstrap package version.
* Update template helper syntax for the new API.

## v0.6.3

* **Update for Meteor 0.9.**

## v0.6.2

* Make sure to run `onLoad` functions non-reactively, in case they access reactive variables.
* Set z-index of dialog modal to be just below that of standard Bootstrap 3 modals.
* Debounce the "Finish" button so that it can't be mashed repeatedly.

## v0.6.1

* Basic support of touch dragging for repositioning the tutorial dialog.
* Tutorial options can now take an `id` field. A tutorial with a given `id` will preserve its current step across a hot code reload (but not a hard reload, as this step is stored in `Session`.)

## v0.6.0

* Now using Bootstrap 3. **Don't try to use this with something that also pulls in Bootstrap 2**.
* Made an `EventEmitter` implementation available on the client. See the example app.
* Improved standalone draggable code for the tutorial dialog.

## v0.5.0

* Preliminary support for Meteor 0.8.0 (Blaze).
* Removed dependency on jQuery UI as it was only used to make the modal draggable.

**NOTE**: This package will be moving to Bootstrap 3. This is the last Bootstrap 2 release.

## v0.4.0

* Improved width/height computations to support some SVG selections.
* Added support for requiring actions to proceed in tutorial steps.
* Allowed both string and direct function references for templates, for more flexible construction of steps.
* Fixed a minor bug with the dialog not being draggable in IE.

## v0.3.0

* Allow for full dimming (`spot: null`) in addition to full brightness (with `spot: "body"`).
* Add the option to specify a finish function. **Note**: breaking changes with previous format.

## v0.2.0

* Added dependency on jQuery UI.
