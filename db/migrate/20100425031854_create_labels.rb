class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string  :name, :null => false
      t.string  :color, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end

    create_table :labels_tasks, :id => false do |t|
      t.integer :label_id, :null => false
      t.integer :task_id, :null => false
    end
  end

  def self.down
    drop_table :labels
  end
end
