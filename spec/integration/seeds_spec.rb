require 'spec_helper'

feature "Seed Data" do
  scenario "The basics" do
    load Rails.root + "db/seeds.rb"
    user = User.find_by_email!("admin@ticketee.com")
    sign_in_as!(user)
    click_link "Ticketee Beta"
    click_link "New Ticket"
    fill_in "Title", :with => "Comments with state"
    fill_in "Description", :with => "Comments always have a state."
    click_button "Create Ticket"
    within("#comment_state_id") do
      page.should have_content("New")
      page.should have_content("Open")
      page.should have_content("Closed")
    end
  end
end
