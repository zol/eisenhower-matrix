(function($){
  tasksIndex = {
    onReady: function() {          
      $(window).resize(function(){tasksIndex.updateQuadrantHeights();});
      this.updateQuadrantHeights();
      
      $(".sortable").sortable({
        connectWith: '.sortable',
        cursor: 'crosshair'
      }).disableSelection();
      
      var emptyFormHTML = $('#new_task').html();
      
      $('#new_task').ajaxForm({success: function(d, s, form){
        var importance = $(d).attr('data-importance');
        var urgency = $(d).attr('data-urgency');
        
        // add it to the correct quadrant (eg '#u1_i1 ol')
        var selector = '#i' + importance + '_u' + urgency + ' ol';
        $(selector).prepend(d);
        
        // reset the form
        $('#new_task').html(emptyFormHTML);
      }});      
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
