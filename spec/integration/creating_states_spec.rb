require 'spec_helper'

feature 'Creating states' do
  before do
    sign_in_as!(Factory(:admin_user))
  end

  scenario "Creating a state" do
    click_link "Admin"
    click_link "States"
    click_link "New State"
    fill_in "Name", :with => "Duplicate"
    click_button "Create State"
    page.should have_content("State has been created.")
  end
end
