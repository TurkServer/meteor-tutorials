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
          y = $drag.offset().top - e.pageY,
          z = $drag.css('z-index');

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
  };
})(jQuery);
