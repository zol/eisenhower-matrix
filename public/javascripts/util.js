(function($) {
  // get importance part of label where label like i0_u1
  $.fn.fw.getImportance = function(label) {
    return label.substring(1,2);
  };
  
  // get urgency part of label where label like i0_u1
  $.fn.fw.getUrgency = function(label) {
    return label.substring(4,5);
  };  
}(jQuery));