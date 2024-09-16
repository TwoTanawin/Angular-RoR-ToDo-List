class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    tasks = Task.all
    render json: tasks.as_json, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
  end

  def show
    tasks = Task.find(params[:id])
    if tasks.present?
      render json: tasks.as_json, status: :ok
    end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "task not found"}, status: :not_found
  end

  def create
    tasks = Task.create(task_params)
    if tasks.save
      render json: tasks.as_json, status: :created
    else
      render json: {errors: tasks.errors.full_messages}, status: :unprocessable_entity
    end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    tasks = Task.find(params[:id])
    if tasks.present?
      tasks.destroy
      render json: {status: 200, id: tasks.id}, status: :ok
    else
      render json: {error: "task not found"}, status: :not_found
    end
    rescue ActiveRecord::RecordNotFound
      render json: {error: tasks.errors.full_messages}, status: :unprocessable_entity
  end

  def update
    tasks = Task.find(params[:id])
    if tasks.present?
      if tasks.update(task_params)
        render json: tasks.as_json, status: :ok
      else
        render json: {error: tasks.errors.full_messages}, status: :unprocessible_entity
      end
    end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "task not found"}, status: :not_found
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :completed)
  end
end
