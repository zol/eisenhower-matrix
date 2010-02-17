/*
Form enhancement and extended form elements live here.
*/

(function($){  
  
  // TODO -- make this one 'widget' too
  // ajaxifies a standard form element. I.E intercepts the submit,
  // submits the form and on failure, replaces the form with the body
  // of the result (i.e the same form with validations)
  $.fn.ajaxForm = function(options) {    
    var settings = $.extend({
      //default callbacks
      error: function(x, t, e, form){        
        if (x.status == 422) {
          //validation failed replace form with new one
          new_form = $(x.responseText);
          $(form).replaceWith(new_form);
          $(new_form).ajaxForm(options);
        } else {
          alert('Form failed. Please try again.');
        }
      },
      success: function(d, s, form){},
      complete: function(x, t, form){},
      submit: function(e){} // return false to cancel submit
    }, options);
    
    return this.each(function(){      
      $(this).bind("submit", function(ev){
        var form = this;
        
        ev.preventDefault();
        
        // run the user defined submit function
        if (settings.submit(ev) === false) return false;
        
        // disable the first submit button on the form
        $(form).find('input[type=submit]:first').attr('disabled', true);
                                
        // send up the form and process the results
        $.ajax({
          cache: false,
          data: $.param($(form).serializeArray()),          
          type: form.method,
          url: form.action,
          error: function (x, t, e) { settings.error(x, t, e, form); },
          success: function (d, s) { settings.success(d, s, form); },
          complete: function (x, t) { 
            // enable the first submit button on the form
            $(form).find('input[type=submit]:first').attr('disabled', false);
            
            settings.complete(x, t, form); 
          }
        });
        
        return false;
      });
    });
  };

  // standardize .focus() for input tags. IE doesn't place the focus at the 
  // end of the input box, this fixes it
  $.fn.inputFocus = function() {
    return this.each(function(){
      if ($.browser.msie) {
        if (this.createTextRange) {
          var FieldRange = this.createTextRange();
          FieldRange.moveStart('character', this.value.length);
          FieldRange.collapse();
          FieldRange.select();
        }
      } else {
        this.focus();
      }
    });
  };
}(jQuery));

