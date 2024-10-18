class User < ApplicationRecord
  has_many :task_assignments
  has_many :tasks, through: :task_assignments

  has_secure_password
end
