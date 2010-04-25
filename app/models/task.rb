class Task < ActiveRecord::Base
  belongs_to :user
  
  has_and_belongs_to_many :labels
  
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
  validates_inclusion_of :current_state, 
                         :in => ['active', 'complete'], 
                         :message => 'invalid state'                            
                            
  before_save :adjust_quadrants
  before_destroy :adjust_positions_for_removal

protected
  
  def adjust_quadrants
    if new_record?
      # 1. Make room in destination list
      adjust_positions_for_insertion
    elsif importance_changed? or urgency_changed? or position_changed?
      # 1. Close gap in original list        
      Task.update_all("position = (position - 1)", 
        "current_state = 'active' AND " + "        
        user_id = #{user_id} AND importance = #{importance_was} AND " + "
        urgency = #{urgency_was} AND position > #{position_was.to_i}")

      # 2. Make room in destination list
      Task.update_all("position = (position + 1)", 
        "current_state = 'active' AND " + "        
        user_id = #{user_id} AND importance = #{importance} AND " + "
        urgency = #{urgency} AND position >= #{position.to_i}")
    elsif current_state_changed?
      if current_state == 'active'
        adjust_positions_for_insertion
      else
        adjust_positions_for_removal
      end
    end
  end

  def adjust_positions_for_insertion
    Task.update_all("position = (position + 1)", 
      "current_state = 'active' AND " + "
      user_id = #{user_id} AND importance = #{importance} AND " + "
      urgency = #{urgency} AND position >= #{position.to_i}")    
  end
        
  def adjust_positions_for_removal
    Task.update_all("position = (position - 1)", 
      "current_state = 'active' AND " + "        
      user_id = #{user_id} AND importance = #{importance} AND " + "
      urgency = #{urgency} AND position > #{position.to_i}")    
  end
end
