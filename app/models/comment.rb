class Comment < ActiveRecord::Base
  attr_accessible :text, :state_id

  after_create :set_ticket_state

  belongs_to :ticket
  belongs_to :user
  belongs_to :state
  validates :text, :presence => true

  delegate :project, :to => :ticket

  private

  def set_ticket_state
    self.ticket.state = self.state
    self.ticket.save!
  end
end

