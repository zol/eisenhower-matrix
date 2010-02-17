# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # the new system: we just put down these metas, and jquery/framework.js reads 
  # them and sets up the onload (specify the layout if u require layout fw js)
  def framework_meta_tags(layout_name = '')
    controller = controller_name.gsub('/', '_').camelcase(:lower)
    view = view_name.camelcase(:lower)
    
    "<meta name='fw.controller' content='#{controller}'/>" + 
    "<meta name='fw.view' content='#{view}'/>" +
    (layout_name != '' ? "<meta name='fw.layout' content='#{layout_name}'/>" : '')
  end
  
  # I'd love to see a better way to grab these
  def controller_name
    @_first_render.base_path || 'no_controller'
  end
  
  def view_name
    @_first_render.name || 'no_view'
  end
  
  # the default classes that get added to the body element when a view renders
  def body_classes
    "c_#{controller_name.gsub('/', '_')} v_#{view_name}"
  end    
  
  # returns 'current' if the current controller/view match those passed in
  def current(c, a)
    (controller.controller_name == c and 
      controller.action_name == a) ? 'current' : ''
  end
  
  def loader_tag
    image_tag 'loader.gif', :id => 'loader'
  end
end
