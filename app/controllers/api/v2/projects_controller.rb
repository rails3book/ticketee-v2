class Api::V2::ProjectsController < Api::V2::BaseController
  before_filter :find_project, :only => [:show, :update, :destroy]

  def index
    projects = Project.for(current_user)
    respond_with(projects, :except => :name, :methods => :title)
  end

  def create
    project = Project.new(params[:project])
    if project.save
      respond_with(project, :location => api_v2_project_path(project))
    else
      respond_with(project)
    end
  end

  def show
    respond_with(@project, :methods => "last_ticket")
  end

  def update
    @project.update_attributes(params[:project])
    respond_with(@project)
  end

  def destroy
    @project.destroy
    respond_with(@project)
  end

  private

  def find_project
    @project = Project.for(current_user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      error = { :error => "The project you were looking for " +
                          "could not be found."}
      respond_with(error, :status => 404)
  end
end
