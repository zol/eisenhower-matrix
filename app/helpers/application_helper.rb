# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # returns 'current' if the current controller/view match those passed in
  def current(c, a)
    (controller.controller_name == c and 
      controller.action_name == a) ? 'current' : ''
  end
end
