module LabelsHelper
  # color is hexcolor
  def is_dark?(color_string)
    color_string.gsub!('#', '') # remove possible #
    color = color_string.to_i(16)
    
    red = color >> 16
    green = (color >> 8) & 0x00ff
    blue = color & 0x0000ff

    (red + green + blue) < 500
  end
  
  def label_text_color(bg_color)
    is_dark?(bg_color) ? 'white' : 'black'
  end
end