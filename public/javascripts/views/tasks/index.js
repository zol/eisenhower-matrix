(function($){
  tasksIndex = {
    onReady: function() {
      // take care of updating vertical heights of quadrants
      $(window).resize(function(){tasksIndex.updateQuadrantHeights();});
      this.updateQuadrantHeights();
      
      // make quadrants sortable
      $(".sortable").sortable({
        connectWith: '.sortable',
        cursor: 'crosshair',
        update: function(event, ui) {
          if (ui.sender == null) // ensure we only fire once
            tasksIndex.taskPositionChanged($(ui.item), $(ui.item).parent());
        }
      }).disableSelection();
      
      // ajaxifize the form
      $('#new_task').ajaxForm({success: function(d, s, form){
        var importance = $(d).attr('data-importance');
        var urgency = $(d).attr('data-urgency');
        
        // add it to the correct quadrant (eg '#u1_i1 ol')
        var selector = '#i' + importance + '_u' + urgency + ' ol';
        $(selector).prepend(d);        
        $(selector + ' li:first').hide().fadeIn('slow'); // fade the fucker in
        
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
      
      // add handler for star
      $('.star').live('click', function(){
        var newStar = $(this).parent().attr('data-star') == 'false' ? true : false;
        $(this).parent().attr('data-star', newStar);
        $.ajax({type: "PUT", url: "/tasks/" + $(this).parent().attr('data-id'), data: {task: {star: newStar}}});
        $('body').toggleClass('hack'); // safari hack to force css refresh
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
    },
    taskPositionChanged: function(task, list) {
      // calculate new item parameters
      var id = $(task).attr('data-id');
      
      var task = {
        task: {
          importance: $.fn.fw.getImportance($(list).parent().attr('id')),
          urgency: $.fn.fw.getUrgency($(list).parent().attr('id')),
          position: $(list).sortable('toArray').indexOf('task_' + id) + 1          
        }
      };
      
      // alert($.param(task));
      
      $.ajax({type: "PUT", url: "/tasks/" + id, data: task});
    }
  }
}(jQuery));
