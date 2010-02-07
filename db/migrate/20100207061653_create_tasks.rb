class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title, :null => false
      t.boolean :star, :default => false, :null => false
      t.integer :importance, :default => 1, :null => false
      t.integer :urgency, :default => 1, :null => false
      t.integer :position, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
