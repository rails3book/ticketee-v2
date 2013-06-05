require 'spec_helper'

feature 'Creating Projects' do
  before do
    sign_in_as!(FactoryGirl.create(:admin_user))
    visit '/'
    click_link 'New Project'
  end

  scenario "can create a project" do
    fill_in 'Name', :with => 'TextMate 2'
    click_button 'Create Project'
    page.should have_content('Project has been created.')

    project = Project.find_by_name("TextMate 2")
    page.current_path.should == project_path(project)
    page.title.should have_content("TextMate 2 - Projects - Ticketee")
  end

  scenario "can not create a project without a name" do
    click_button 'Create Project'
    page.should have_content("Project has not been created.")
    page.should have_content("Name can't be blank")
  end
end
