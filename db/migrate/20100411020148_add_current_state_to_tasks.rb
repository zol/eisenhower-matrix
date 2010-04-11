class AddCurrentStateToTasks < ActiveRecord::Migration  
  def self.up
    add_column :tasks, :current_state, :string, :default => 'active', :null => false
    Task.update_all :current_state => 'active'
  end

  def self.down
    remove_column :tasks, :current_state
  end
end
