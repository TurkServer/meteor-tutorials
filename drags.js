var touchSupported = 'ontouchend' in document;

// Modified from http://css-tricks.com/snippets/jquery/draggable-without-jquery-ui/
// so that we don't have an unnecessary dependency on jQuery UI

// However, this code is significantly less shitty

(function($) {
  $.fn.drags = function(options) {
    options = $.extend({
      handle: null,
      cursor: 'move',
      draggingClass: 'dragging'
    }, options);

    var $handle = this,
      $drag = this;

    if( options.handle ) {
      $handle = $(options.handle);
    }

    $handle
      .css('cursor', options.cursor)
      .on("mousedown", function(e) {
        var x = $drag.offset().left - e.pageX,
          y = $drag.offset().top - e.pageY;

        $(document.documentElement)
          .on('mousemove.drags', function(e) {
            $drag.offset({
              left: x + e.pageX,
              top: y + e.pageY
            });
          })
          .one('mouseup', function() {
            $(this).off('mousemove.drags');
          });

        // disable selection
        e.preventDefault();
      });

    if( touchSupported ) {
      initTouchDrag($handle[0]);
    }
  };
})(jQuery);

// Make touch events work:
// http://stackoverflow.com/a/6362527/586086
function touchHandler(event) {
  var touch = event.changedTouches[0];

  var simulatedEvent = document.createEvent("MouseEvent");
  simulatedEvent.initMouseEvent({
    touchstart: "mousedown",
    touchmove: "mousemove",
    touchend: "mouseup"
  }[event.type], true, true, window, 1,
    touch.screenX, touch.screenY,
    touch.clientX, touch.clientY, false,
    false, false, false, 0, null);

  touch.target.dispatchEvent(simulatedEvent);
  // Clicks should continue to work
  if( event.type === "touchmove" ) event.preventDefault();
}

function initTouchDrag(element) {
  element.addEventListener("touchstart", touchHandler, true);
  element.addEventListener("touchmove", touchHandler, true);
  element.addEventListener("touchend", touchHandler, true);
  element.addEventListener("touchcancel", touchHandler, true);
}
