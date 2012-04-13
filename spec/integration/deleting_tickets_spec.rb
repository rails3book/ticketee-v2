require 'spec_helper'

feature 'Deleting tickets' do
  let!(:project) { Factory(:project) }
  let!(:ticket) { Factory(:ticket, :project => project) }

  before do
    visit '/'
    click_link project.name
    click_link ticket.title
  end

  scenario "Deleting a ticket" do
    click_link "Delete Ticket"
    page.should have_content("Ticket has been deleted.")
    page.current_url.should == project_url(project)
  end

end
