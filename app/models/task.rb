class Task < ActiveRecord::Base
  belongs_to :user
  
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
                            
  before_save :adjust_quadrants

protected
  
  def adjust_quadrants
    if new_record?
      # 1. Make room in destination list
      Task.update_all("position = (position + 1)", 
        "user_id = #{user_id} AND importance = #{importance} AND " + "
        urgency = #{urgency} AND position >= #{position.to_i}")
    else
      if importance_changed? or urgency_changed? or position_changed?
        # 1. Close gap in original list        
        Task.update_all("position = (position - 1)", 
          "user_id = #{user_id} AND importance = #{importance_was} AND " + "
          urgency = #{urgency_was} AND position > #{position_was.to_i}")
  
        # 2. Make room in destination list
        Task.update_all("position = (position + 1)", 
          "user_id = #{user_id} AND importance = #{importance} AND " + "
          urgency = #{urgency} AND position >= #{position.to_i}")
      end
    end
  end
end
