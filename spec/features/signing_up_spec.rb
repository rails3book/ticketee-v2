require 'spec_helper'

feature 'Signing up' do
  scenario 'Successful sign up' do
    visit '/'
    within 'nav' do
      click_link 'Sign up'
    end
    fill_in "Email", :with => "user@ticketee.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign up"
    page.should have_content("Please open the link to activate your account.")
  end
end
