require "spec_helper"

describe "/api/v1/projects", :type => :api do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { user.authentication_token }
  let!(:project) { FactoryGirl.create(:project) }

  before do
    user.permissions.create!(:action => "view", :thing => project)
  end

  context "projects viewable by this user" do

    before do
      FactoryGirl.create(:project, :name => "Access Denied")
    end

    let(:url) { "/api/v1/projects" }
    it "json" do
      get "#{url}.json", :token => token

      projects_json = Project.for(user).all.to_json
      response.body.should eql(projects_json)
      response.status.should eql(200)

      projects = JSON.parse(response.body)

      projects.any? do |p|
        p["name"] == project.name
      end.should be_true

      projects.any? do |p|
        p["name"] == "Access Denied"
      end.should be_false
    end

    it "XML" do
      get "#{url}.xml", :token => token
      response.body.should eql(Project.for(user).to_xml)
      projects = Nokogiri::XML(response.body)
      projects.css("project name").text.should eql(project.name)
    end
  end

  context "creating a project" do
    before do
      user.admin = true
      user.save
    end

    let(:url) { "/api/v1/projects" }

    it "successful JSON" do
      post "#{url}.json", :token => token,
                          :project => {
                            :name => "Inspector"
                          }

      project = Project.find_by_name!("Inspector")
      route = "/api/v1/projects/#{project.id}"

      response.status.should eql(201)
      response.headers["Location"].should eql(route)
      response.body.should eql(project.to_json)
    end

    it "unsuccessful JSON" do
      post "#{url}.json", :token => token,
                          :project => {}
      response.status.should eql(422)
      errors = {"errors" => {
                 "name" => ["can't be blank"]
               }}.to_json
      response.body.should eql(errors)
    end
  end

  context "show" do
    let(:url) { "/api/v1/projects/#{project.id}"}

    before do
      FactoryGirl.create(:ticket, :project => project)
    end

    it "JSON" do
      get "#{url}.json", :token => token
      project_json = project.to_json(:methods => "last_ticket")
      response.body.should eql(project_json)
      response.status.should eql(200)

      project_response = JSON.parse(response.body)

      ticket_title = project_response["last_ticket"]["title"]
      ticket_title.should_not be_blank
    end
  end

  context "updating a project" do
    before do
      user.admin = true
      user.save
    end

    let(:url) { "/api/v1/projects/#{project.id}" }
    it "successful JSON" do
      put "#{url}.json", :token => token,
                         :project => {
                            :name => "Not Ticketee"
                          }

      response.status.should eql(204)
      response.body.should eql("")

      project.reload
      project.name.should eql("Not Ticketee")
    end

    it "unsuccessful JSON" do
      put "#{url}.json", :token => token,
                         :project => {
                           :name => ""
                          }
      response.status.should eql(422)
      errors = { :errors => { :name => ["can't be blank"] } }
      response.body.should eql(errors.to_json)
    end
  end

  context "deleting a project" do
    before do
      user.admin = true
      user.save
    end

    let(:url) { "/api/v1/projects/#{project.id}" }
    it "JSON" do
      delete "#{url}.json", :token => token
      response.status.should eql(204)
    end
  end
end
