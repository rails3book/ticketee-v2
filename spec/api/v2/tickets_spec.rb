require 'spec_helper'

describe "/api/v1/tickets", :type => :api do
  let!(:project) { FactoryGirl.create(:project, :name => "Ticketee") }
  let!(:user) { FactoryGirl.create(:user) }

  before do
    user.permissions.create!(:action => "view",
                             :thing => project)
  end

  let(:token) { user.authentication_token }
  let(:url) { "/api/v1/projects/#{project.id}/tickets" }

  it "XML" do
    get "#{url}.xml", :token => token
    last_response.body.should eql(project.tickets.to_xml)
  end

  it "JSON" do
    get "#{url}.json", :token => token
    last_response.body.should eql(project.tickets.to_json)
  end
end

