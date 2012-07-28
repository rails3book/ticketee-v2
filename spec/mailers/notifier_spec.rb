require 'spec_helper'

describe Notifier do
  context "comment_updated" do
    let!(:project) { Factory(:project) }
    let!(:ticket_owner) { Factory(:user) }
    let!(:ticket) { Factory(:ticket, :project => project,
                                    :user => ticket_owner) }
    let!(:commenter) { Factory(:user) }
    let(:comment) do
      Comment.new({
        :ticket => ticket,
        :user => commenter,
        :text => "Test comment"
      }, :without_protection => true)
    end

    let(:email) do
       Notifier.comment_updated(comment, ticket_owner)
    end

    it "sends out an email notification about a new comment" do
      email.to.should include(ticket_owner.email)
      title = "#{ticket.title} for #{project.name} has been updated."
      email.body.should include(title)
      email.body.should include("#{comment.user.email} wrote:")
      email.body.should include(comment.text)
    end

    it "correctly sets the Reply-To" do
      address = "youraccount+#{project.id}+#{ticket.id}@gmail.com"
      email.reply_to.should == [address]
    end
  end
end
