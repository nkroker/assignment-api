class CreateTaskAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :task_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :assigned_by

      t.timestamps
    end
  end
end
