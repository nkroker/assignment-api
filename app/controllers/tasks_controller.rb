class TasksController < ApplicationController
  before_action :authorize_request
  before_action :check_admin, only: [:create, :assign]
  before_action :set_task, only: [:assign, :complete]
  before_action :check_task_association, only: [:assign, :complete]

  def create
    task = Task.new(task_params)
    task.created_by_id = @current_user.id

    if task.save
      render json: { message: 'Task created successfully' }, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def assign
    task_assignment = task.task_assignments.new(
      user_id: params[:user_id],
      assigned_by_id: @current_user.id
    )

    if task_assignment.save
      render json: { message: "Task assigned to the user" }, status: :ok
    else
      render json: { errors: task_assignment.errors }, status: :unprocessable_entity
    end
  end

  # member role actions
  def assigned
    task_assignments = @current_user.task_assignments

    render json: task_assignments, status: :ok
  end

  def complete
    if @task.update(completed: true)
      render json: { message: "Task completed" }, status: :ok
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  private

  def check_task_association
    not_found unless assigned_to_current_user? unless @current_user.has_admin_role?
    not_found unless created_by_current_user?
  end

  def task_params
    params.permit(:title, :description)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def check_admin
    unless @current_user.has_admin_role?
      render json: { message: "You are not authorized to perform this action" }, status: :unauthorized
    end
  end

  def created_by_current_user?
    @task.created_by_id == @current_user.id if @current_user.has_admin_role?
  end

  def assigned_to_current_user?
    @task.task_assignments.find_by(user_id:@current_user.id).present?
  end
end
