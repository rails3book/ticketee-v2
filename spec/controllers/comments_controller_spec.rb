require 'spec_helper'

describe CommentsController do
  let(:user) { Factory(:confirmed_user) }
  let(:project) { Project.create!(:name => "Ticketee") }

  let(:ticket) do
    ticket = project.tickets.build(:title => "State transitions",
                                   :description => "Can't be hacked.")
    ticket.user = user
    ticket.save
    ticket
  end

  let(:state) { State.create!(:name => "New") }

  context "a user without permission to set state" do
    before do
      sign_in(:user, user)
    end

    it "cannot transition a state by passing through state_id" do
      post :create, { :comment => { :text => "Hacked!",
        :state_id => state.id },
        :ticket_id => ticket.id }
      ticket.reload
      ticket.state.should eql(nil)
    end
  end

  context "a user without permission to tag a ticket" do
    before do
      sign_in(:user, user)
    end

    it "cannot tag a ticket when creating a comment" do
      post :create, { :comment => {
                        :text => "Tag!",
                        :tag_names => "one two"
                      },
                      :ticket_id => ticket.id
                     }
      ticket.reload
      ticket.tags.should be_empty
    end
  end

end
