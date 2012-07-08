require 'spec_helper'

feature "Searching" do
  let!(:user) { Factory(:confirmed_user) }
  let!(:project) { Factory(:project) }
  let!(:ticket_1) do
    Factory(:ticket,
            :title => "Create projects",
            :project => project,
            :user => user,
            :tag_names => "iteration_1")
  end

  let!(:ticket_2) do
    Factory(:ticket,
            :title => "Create users",
            :project => project,
            :user => user,
            :tag_names => "iteration_2")
  end

  before do
    define_permission!(user, "view", project)

    sign_in_as!(user)
    visit '/'
    click_link project.name
  end

  scenario "Finding by tag" do
    fill_in "Search", :with => "tag:iteration_1"
    click_button "Search"
    page.should have_content("Create projects")
    page.should_not have_content("Create users")
  end
end
