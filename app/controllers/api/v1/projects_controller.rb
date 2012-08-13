class Api::V1::ProjectsController < Api::V1::BaseController
  def index
    respond_with(Project.for(current_user).all)
  end

  def create
    project = Project.new(params[:project])
    if project.save
      respond_with(project, :location => api_v1_project_path(project))
    else
      respond_with(project)
    end
  end

  def show
    project = Project.find(params[:id])
    respond_with(project, :methods => "last_ticket")
  end
end
