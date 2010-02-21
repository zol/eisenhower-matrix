(function($) {
  $.fn.fw.quadrant_chooser = function() {
    return this.each(function(){
      var chooser = $(this);
      
      updateChosenQuadrant(chooser);
      
      // update the form fields according to the user's chosen click
      chooser.find('div').click(function() {
        var importance;
        var urgency;
        
        // HACKEY
        if ($(this).hasClass('i1_u0')) {
          importance = '1';
          urgency = '0';
        } else if ($(this).hasClass('i1_u1')) {
          importance = '1';
          urgency = '1';
        } else if ($(this).hasClass('i0_u0')) {
          importance = '0';
          urgency = '0';
        } else if ($(this).hasClass('i0_u1')) {
          importance = '0';
          urgency = '1';
        }
        
        chooser.parent().find('#task_importance').val(importance);
        chooser.parent().find('#task_urgency').val(urgency);
        
        updateChosenQuadrant(chooser);
        
        // re-focus title input
        $('#task_title').inputFocus();
      });
    });
    
    function updateChosenQuadrant(chooser) {
      chooser.find('div').removeClass('selected');
      
      // set the selected quadrant
      var importance = chooser.parent().find('#task_importance').val();
      var urgency = chooser.parent().find('#task_urgency').val();
      var selector = '.i' + importance + '_u' + urgency;
      chooser.find(selector).addClass('selected');
    }    
  };
}(jQuery));