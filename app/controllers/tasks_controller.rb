class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :update]
  
  def index

  end

  def create
    
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "タスクが正常に投稿されました"
      redirect_to root_url
    else
      @tasks = current_user.tasks.order("created_at DESC").page(params[:page])
      flash.now[:danger] = "タスクの投稿に失敗しました"
      render "toppages/index"
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "タスクの更新に成功しました"
      redirect_to root_url
    else
      flash.now[:danger] = "タスクの更新に失敗しました"
      render "tasks/edit"
    end
  end

  def destroy

    @task.destroy
    
    flash[:success] = "タスクは正常に削除されました"
    redirect_back(fallback_location: root_path)
  end

  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])

    unless @task
      redirect_to root_url
    end
    
  end
  
end
