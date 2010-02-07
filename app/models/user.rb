class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :tasks, :dependent => :destroy, :order => 'importance, urgency, position'
  
  validates_associated :tasks
  validates_length_of :invitation_code, :is => 8
  validate :correct_invitation_code, :on => :create
  
protected
  
  def correct_invitation_code
    # add all numbers together and check if they equal 27 :) (e.g 7f91j28 or 99900000)
    digit_sum = self.invitation_code.gsub(/[^\d]/, '').split(//).inject(0){|sum,item| sum + item.to_i}    
    
    if digit_sum != 27
      errors.add(:invitation_code, "is invalid") 
    end
  end
end
