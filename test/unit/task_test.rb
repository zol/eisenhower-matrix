require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:zol)
  end
  
  test "reposition_within_quadrant" do
    t = tasks(:apple2)
    t.new_position = 1
    t.save
    
    check_task tasks(:apple1), 2, 1, 0
    check_task tasks(:apple2), 1, 1, 0 #<- we moved it to pos 1
    check_task tasks(:apple3), 3, 1, 0
    
    check_bananas
    check_carrots
    check_durians
  end
  
  test "reposition_between_quadrants" do
    t = tasks(:apple2) # move it to the bananas
    t.new_position = 2
    t.importance = 1
    t.urgency = 1    
    t.save

    check_task tasks(:banana1), 1, 1, 1
    check_task tasks(:apple2),  2, 1, 1 #<- we moved it to pos 2    
    check_task tasks(:banana2), 3, 1, 1    

    check_task tasks(:apple1), 1, 1, 0
    # apple 2 is missing from here
    check_task tasks(:apple3), 2, 1, 0
    
    check_carrots
    check_durians
  end
  
  
  def check_bananas
    check_task tasks(:banana1), 1, 1, 1
    check_task tasks(:banana2), 2, 1, 1    
  end
  
  def check_carrots
    check_task tasks(:carrot1), 1, 0, 0    
  end  
  
  def check_durians
    check_task tasks(:durian1), 1, 0, 1
  end    
  
  def check_task(task, position, importance, urgency)
    assert task.position == position
    assert task.importance == importance
    assert task.urgency == urgency
  end  
end
