class User < ApplicationRecord
  has_many :task_assignments
  has_many :tasks, through: :task_assignments

  before_action :encrypt_password

  def encrypt_password
  end
end
