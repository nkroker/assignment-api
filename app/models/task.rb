class Task < ApplicationRecord
  has_many :task_assignments
  has_many :users, through: :task_assignments
end
