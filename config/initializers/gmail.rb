# configuration for the gmail gem
#
# put the following lines in your ~/.bash_profile or ~/.zshrc to make mail sending work
#
# export GMAIL_USERNAME='<your email address>'
# export GMAIL_PASSWORD='<your password>'

ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  domain: 'example.com',
  user_name: ENV.fetch('GMAIL_USERNAME', 'test@example.com'),
  password: ENV.fetch('GMAIL_PASSWORD', 'secret'),
  authentication: 'plain',
  enable_starttls_auto: true
}
