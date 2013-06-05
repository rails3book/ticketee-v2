require 'spec_helper'

describe ProjectsController do
  let(:user) { FactoryGirl.create(:confirmed_user) }
  let(:project) { FactoryGirl.create(:project) }


  context "standard users" do
    before do
      sign_in(:user, user)
    end

    { :new => :get,
      :create => :post,
      :edit => :get,
      :update => :put,
      :destroy => :delete }.each do |action, method|
        it "cannot access the #{action} action" do
          sign_in(:user, user)
          send(method, action, :id => project.id)
          response.should redirect_to(root_path)
          flash[:alert].should eql("You must be an admin to do that.")
        end
      end

    it "cannot access the show action without permission" do
      sign_in(:user, user)
      get :show, :id => project.id
      response.should redirect_to(projects_path)
      flash[:alert].should eql("The project you were looking for could not be found.")
    end
  end

  it "displays an error for a missing project" do
    sign_in(:user, user)
    get :show, :id => "not-here"
    response.should redirect_to(projects_path)
    message = "The project you were looking for could not be found."
    flash[:alert].should == message
  end
end
