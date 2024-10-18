class TaskAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :task
  belongs_to :assigned_by
end
