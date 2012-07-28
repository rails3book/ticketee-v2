require 'spec_helper'

feature "Gmail" do
  let!(:alice) { Factory(:confirmed_user) }
  let!(:me) { Factory(:confirmed_user, :email => "radarlistener@gmail.com") }
  let!(:project) { Factory(:project) }
  let!(:ticket) do
    Factory(:ticket, :project => project,
                     :user => me)
  end

  before do
    ActionMailer::Base.delivery_method = :smtp
    define_permission!(alice, "view", project)
    define_permission!(me, "view", project)
  end

  after do
    ActionMailer::Base.delivery_method = :test
  end

  scenario "Receiving a real-world email" do
    sign_in_as!(alice)
    visit project_ticket_path(project, ticket)
    fill_in "comment_text", :with => "Posting a comment1"
    click_button "Create Comment"
    page.should have_content("Comment has been created.")

    ticketee_emails.count.should == 1
    email = ticketee_emails.first
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    email.subject.should == subject
    clear_ticketee_emails!
  end
end
