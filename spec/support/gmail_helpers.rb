module GmailHelpers
  def gmail_connection
    settings = ActionMailer::Base.smtp_settings
    @gmail_connection ||= Gmail.connect(settings[:user_name],
                                        settings[:password])
  end

  def ticketee_emails
    gmail_connection.inbox.find(:unread,
                                :from => "Ticketee App")
  end

  def clear_ticketee_emails!
    ticketee_emails.map(&:delete!)
  end
end

RSpec.configure do |c|
  c.include GmailHelpers
end
