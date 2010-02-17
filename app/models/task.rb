class Task < ActiveRecord::Base
  belongs_to :user
  acts_as_list :scope => 'user_id = #{user_id} AND importance = #{importance} AND urgency = #{urgency}'
  
  validates_presence_of :title, :user
  validates_length_of :title, :in => 0..80
  validates_numericality_of :importance, 
                            :greater_than_or_equal_to => 0, 
                            :less_than_or_equal_to => 1, 
                            :only_integer => true
  validates_numericality_of :urgency, 
                            :greater_than_or_equal_to => 0, 
                            :less_than_or_equal_to => 1, 
                            :only_integer => true
end
