require "spec_helper"

describe "/api/v1/projects", :type => :api do
  let!(:user) { Factory(:user) }
  let!(:token) { user.authentication_token }
  let!(:project) { Factory(:project) }

  before do
    user.permissions.create!(:action => "view", :thing => project)
  end

  context "projects viewable by this user" do

    before do
      Factory(:project, :name => "Access Denied")
    end

    let(:url) { "/api/v1/projects" }
    it "json" do 
      get "#{url}.json", :token => token

      projects_json = Project.for(user).all.to_json
      last_response.body.should eql(projects_json)
      last_response.status.should eql(200)

      projects = JSON.parse(last_response.body)

      projects.any? do |p|
        p["name"] == project.name
      end.should be_true

      projects.any? do |p|
        p["name"] == "Access Denied"
      end.should be_false
    end

    it "XML" do
      get "#{url}.xml", :token => token
      last_response.body.should eql(Project.for(user).to_xml)
      projects = Nokogiri::XML(last_response.body)
      projects.css("project name").text.should eql(project.name)
    end
  end

  context "creating a project" do

    let(:url) { "/api/v1/projects" }

    it "successful JSON" do
      post "#{url}.json", :token => token,
                          :project => {
                            :name => "Inspector"
                          }

      project = Project.find_by_name("Inspector")
      route = "/api/v1/projects/#{project.id}"

      last_response.status.should eql(201)
      last_response.headers["Location"].should eql(route)
      last_response.body.should eql(project.to_json)
    end
  end
end
