(function($){
  tasksIndex = {
    onReady: function() {
      // take care of updating vertical heights of quadrants
      $(window).resize(function(){tasksIndex.updateQuadrantHeights();});
      this.updateQuadrantHeights();
      
      // make quadrants sortable
      $(".sortable").sortable({
        connectWith: '.sortable',
        cursor: 'crosshair'
      }).disableSelection();
      
      // ajaxifize the form
      $('#new_task').ajaxForm({success: function(d, s, form){
        var importance = $(d).attr('data-importance');
        var urgency = $(d).attr('data-urgency');
        
        // add it to the correct quadrant (eg '#u1_i1 ol')
        var selector = '#i' + importance + '_u' + urgency + ' ol';
        // $(d).hide();
        $(selector).prepend(d);//.find(d).hide().fadeIn('slow');
        
        // reset the form
        // $('#new_task').html(emptyFormHTML);
        $('#new_task input[type=text]').val('');
        $('#new_task .fieldWithErrors input').unwrap();
      }});
      
      // add handler for delete. fade it out then remove it on server
      $('.quadrant li .delete').live('click', function(){
        $(this).parent().fadeOut('slow', function(){ $(this).remove(); });
        $.ajax({type: "DELETE", url: "/tasks/" + $(this).parent().attr('data-id')});
      });
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
