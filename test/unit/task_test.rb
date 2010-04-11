$: << File.join(File.dirname(__FILE__), '..')

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:zol)
  end
  
  test "reposition_within_quadrant" do
    t = tasks(:apple2)
    t.position = 1
    t.save
    
    check_task tasks(:apple2), 1, 1, 0 #<- we moved it to pos 1  
    check_task tasks(:apple1), 2, 1, 0
    check_task tasks(:apple3), 3, 1, 0
    
    check_bananas
    check_carrots
    check_durians
  end
  
  test "reposition_between_quadrants1" do
    t = tasks(:apple2) # move it to the bananas
    t.position = 2
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
  
  test "inserts_positioned_correctly" do
    # first insert one
    b3 = users(:zol).tasks.create(:title => 'Banana3')

    check_task b3, 1, 1, 1
    check_task tasks(:banana1), 2, 1, 1
    check_task tasks(:banana2), 3, 1, 1
    
    # then insert more
    b4 = users(:zol).tasks.create(:title => 'Banana4')
    
    # be sure to refresh all the data as we are doing underlying SQL updates
    tasks(:banana1).reload
    tasks(:banana2).reload
    b3.reload
    b4.reload
    
    check_task b4, 1, 1, 1
    check_task b3, 2, 1, 1
    check_task tasks(:banana1), 3, 1, 1
    check_task tasks(:banana2), 4, 1, 1    
  end

  test "reposition_between_quadrants2" do
    # move all bananas to the end of apples
    t = tasks(:banana1) 
    t.position = 4
    t.importance = 1
    t.urgency = 0
    t.save
    
    t = tasks(:banana2) 
    t.position = 5
    t.importance = 1
    t.urgency = 0
    t.save    

    check_task tasks(:apple1), 1, 1, 0
    check_task tasks(:apple2), 2, 1, 0
    check_task tasks(:apple3), 3, 1, 0
    check_task tasks(:banana1), 4, 1, 0
    check_task tasks(:banana2), 5, 1, 0
    
    check_carrots
    check_durians
  end
  
  test "delete" do
    tasks(:apple2).destroy
    
    check_task tasks(:apple1), 1, 1, 0
    # check_task tasks(:apple2), 2, 1, 0
    check_task tasks(:apple3), 2, 1, 0
    
    check_bananas
    check_carrots
    check_durians
  end

  test "make_complete" do
    tasks(:apple2).update_attributes(:current_state => 'complete')
    
    check_task tasks(:apple1), 1, 1, 0
    # check_task tasks(:apple2), 2, 1, 0
    check_task tasks(:apple3), 2, 1, 0
    
    check_bananas
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
    assert task.position == position, "Position #{position} incorrect for Task #{task.title}"
    assert task.importance == importance, "Importance #{importance} incorrect for Task #{task.title}"
    assert task.urgency == urgency, "Urgency #{importance} incorrect for Task #{task.title}"
  end  
end
