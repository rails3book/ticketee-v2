class Notifier < ActionMailer::Base
  # default from: "Ticketee App <#{ActionMailer::Base.smtp_settings[:user_name]}>"
  default from: "from@example.com"

  def comment_updated(comment, user)
    @comment = comment
    @user = comment.user
    @ticket = comment.ticket
    @project = @ticket.project
    subject = "[ticketee] #{@project.name} - #{@ticket.title}"
    mail(:to => user.email, :subject => subject)
  end
end
