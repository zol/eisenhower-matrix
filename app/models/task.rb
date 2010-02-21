class Task < ActiveRecord::Base
  belongs_to :user
  acts_as_list :scope => 'user_id = #{user_id} AND importance = #{importance} AND urgency = #{urgency}'
  
  validates_presence_of :title, :user
  validates_length_of :title, :in => 0..200
  validates_numericality_of :importance, 
                            :greater_than_or_equal_to => 0, 
                            :less_than_or_equal_to => 1, 
                            :only_integer => true
  validates_numericality_of :urgency, 
                            :greater_than_or_equal_to => 0, 
                            :less_than_or_equal_to => 1, 
                            :only_integer => true
                            
  after_create :move_to_top
  before_save :reposition

  # this will trigger the repositioning
  def new_position=(num)
    @new_position = num
  end
  
protected
  
  def reposition
    if @new_position and not @repositioning
      @repositioning = true # avoid endless loop

      quadrants_changed = true if importance_changed? or urgency_changed?
      old_importance = importance_was
      old_urgency = urgency_was
      old_position = position
      
      # always update the position first. this will update all the other tasks
      # in this task's quadrant
      insert_at(@new_position)
      
      # next if the quadrants have changed, ensure the hole in the quadrant 
      # the task came from is fixed, if it exists
      if quadrants_changed
        Task.update_all("position = (position - 1)", 
          "user_id = #{user_id} AND importance = #{old_importance} AND " + "
          urgency = #{old_urgency} AND position > #{old_position.to_i}")
      end
    end
  end  
end
