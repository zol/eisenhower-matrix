(function($){
  labelsIndex = {
    onReady: function() {
      // setup the color picker
      $('.colorpicker').colorPicker({
        defaultColor: 5,
        click: function(color){$('#label_color').val(color);},
      });
      
      // ajaxifize the form
      $('#new_label').ajaxForm({success: function(d, s, form){
        // add the label to the list
        $('.labels').prepend(d);        
        
        // reset the form
        $('#new_label input[type=text]').val('');
        $('#new_label .fieldWithErrors input').unwrap();
      }});
      
    }
  }
}(jQuery));
