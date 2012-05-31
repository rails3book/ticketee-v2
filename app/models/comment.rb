class Comment < ActiveRecord::Base
  attr_accessible :text, :ticket_id, :user_id

  belongs_to :user

  validates :text, :presence => true
end
