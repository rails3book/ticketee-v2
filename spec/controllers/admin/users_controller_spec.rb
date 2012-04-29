require 'spec_helper'

describe Admin::UsersController do
  let(:user) { Factory(:confirmed_user) }

  context "standard users" do
    before { sign_in(:user, user) }

    it "are not able to access the index action" do
      get 'index'
      response.should redirect_to('/')
      flash[:alert].should eql("You must be an admin to do that.")
    end
  end
end
