require 'spec_helper'

feature 'Editing a user' do
  let!(:admin_user) { Factory(:admin_user) }
  let!(:user) { Factory(:confirmed_user) }

  before do
    sign_in_as!(admin_user)
    visit '/'
    click_link "Admin"
    click_link "Users"
    click_link user.email
    click_link "Edit User"
  end

  scenario "Updating a user's details" do
    fill_in "Email", :with => "newguy@example.com"
    click_button "Update User"
    page.should have_content("User has been updated.")
    within("#users") do
      page.should have_content("newguy@example.com")
      page.should_not have_content(user.email)
    end
  end

  scenario "Toggling user's admin ability" do
    check "Is an admin?"
    click_button "Update User"
    page.should have_content("User has been updated.")
    within("#users") do
      page.should have_content("#{user.email} (Admin)")
    end
  end

  scenario "Updating with an invalid email fails" do
    fill_in "Email", :with => "fakefakefake"
    click_button "Update User"
    page.should have_content("User has not been updated")
    page.should have_content("Email is invalid")
  end
end
