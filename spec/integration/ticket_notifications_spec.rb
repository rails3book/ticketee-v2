require "spec_helper"
feature "Ticket Notifications" do
  let!(:alice) { Factory(:confirmed_user, :email => "alice@example.com") }
  let!(:bob) { Factory(:confirmed_user, :email => "bob@example.com") }
  let!(:project) { Factory(:project) }
  let!(:ticket) do
    Factory(:ticket,
            :project => project,
            :user => alice)
  end

  before do
    ActionMailer::Base.deliveries.clear

    define_permission!(alice, "view", project)
    define_permission!(bob, "view", project)

    sign_in_as!(bob)
    visit '/'
  end

  scenario "Ticket owner receives notifications about comments" do
    click_link project.name
    click_link ticket.title
    fill_in "comment_text", :with => "Is it out yet?"
    click_button  "Create Comment"

    email = open_last_email_for(alice.email)
    email.should_not(be_nil, "Couldn't open email for #{alice.email}")
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    email.subject.should include(subject)
    email.body.should include("updated the #{ticket.title} ticket")
    click_first_link_in_email

    within("#ticket h2") do
      page.should have_content(ticket.title)
    end
  end
end
