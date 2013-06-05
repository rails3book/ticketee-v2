require "spec_helper"
feature "Ticket Notifications" do
  let!(:alice) { FactoryGirl.create(:confirmed_user, :email => "alice@example.com") }
  let!(:bob) { FactoryGirl.create(:confirmed_user, :email => "bob@example.com") }
  let!(:project) { FactoryGirl.create(:project) }
  let!(:ticket) do
    FactoryGirl.create(:ticket,
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

    email = find_email!(alice.email)
    subject = "[ticketee] #{project.name} - #{ticket.title}"
    email.subject.should include(subject)
    click_first_link_in_email(email)

    within("#ticket h2") do
      page.should have_content(ticket.title)
    end
  end

  scenario "Comment authors are automatically subscribed to a ticket" do
    click_link project.name
    click_link ticket.title
    fill_in "comment_text", :with => "Is it out yet?"
    click_button "Create Comment"
    page.should have_content("Comment has been created.")
    find_email!(alice.email)
    click_link "Sign out"

    reset_mailer

    sign_in_as!(alice)
    click_link project.name
    click_link ticket.title
    fill_in "comment_text", :with => "Not yet!"
    click_button "Create Comment"
    page.should have_content("Comment has been created.")
    find_email!(bob.email)
    lambda { find_email!(alice.email) }.should raise_error
  end
end
