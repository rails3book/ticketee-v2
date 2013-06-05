require 'spec_helper'

feature "Deleting projects" do
  before do
    sign_in_as!(FactoryGirl.create(:admin_user))
  end

  scenario "Deleting a project" do
    FactoryGirl.create(:project, :name => "TextMate 2")
    visit "/"
    click_link "TextMate 2"
    click_link "Delete Project"
    page.should have_content("Project has been deleted.")

    visit "/"
    page.should_not have_content("TextMate 2")
  end
end
