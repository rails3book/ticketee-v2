class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_ticket

  def create
    sanitize_parameters!
    @comment = @ticket.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Comment has been created."
      redirect_to [@ticket.project, @ticket]
    else
      @states = State.all
      flash[:alert] = "Comment has not been created."
      render :template => "tickets/show"
    end
  end

  private

  def find_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def sanitize_parameters!
    if cannot?(:"change states", @ticket.project)
      params[:comment].delete(:state_id)
    end

    if cannot?(:tag, @ticket.project)
      params[:comment].delete(:tag_names)
    end
  end
end
