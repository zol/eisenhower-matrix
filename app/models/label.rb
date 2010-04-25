class Label < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :color
  validates_length_of :name, :in => 0..100
  validates_length_of :color, :in => 0..20
end
