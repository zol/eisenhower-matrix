(function($){
  tasksIndex = {
    onReady: function() {          
      $(window).resize(function(){tasksIndex.updateQuadrantHeights();});
      this.updateQuadrantHeights();
      
      $(".sortable").sortable({
        connectWith: '.sortable',
        cursor: 'crosshair'
      }).disableSelection();
    },
    updateQuadrantHeights: function() {
      var windowHeight = $(window).height();
      var headerHeight = $('#header').outerHeight();
      var footerHeight = $('#footer').outerHeight();
      
      var contentHeight = windowHeight - headerHeight - footerHeight;
      var quadrantHeight = contentHeight / 2;

      $('#content').height(contentHeight);
      $('.quadrant').height(quadrantHeight);
      $('.quadrant ol').height(quadrantHeight); //also size the lists
    }
  }
}(jQuery));
