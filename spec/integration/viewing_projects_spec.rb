require 'spec_helper'

feature "Viewing projects" do
  let!(:user) { Factory(:confirmed_user) }
  let!(:project) { Factory(:project) }

  before do
    sign_in_as!(user)
    define_permission!(user, :view, project)
  end

  scenario "Listing all projects" do
    visit '/'
    click_link project.name
    page.current_url.should == project_url(project)
  end
end
