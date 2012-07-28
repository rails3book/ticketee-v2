require 'spec_helper'

describe Receiver do
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

  it "parses a reply from a comment update into a comment" do
    original = Notifier.comment_updated(comment, ticket_owner)
    reply_text = "This is a brand new comment"
    reply = Mail.new(:from => "user@ticketee.com",
                     :subject => "Re: #{original.subject}",
                     :body => %Q{#{reply_text}
                          #{original.body}
                     },
                     :to => original.reply_to)
    lambda { Receiver.parse(reply) }.should(
     change(comment.ticket.comments, :count).by(1)
   )
   ticket.comments.last.text.should eql(reply_text)
  end
end
