class Project < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :tickets

  has_many :permissions, :as => :thing
  def self.viewable_by(user)
    joins(:permissions).where(:permissions => { :action => "view",
                              :user_id => user.id })
  end
end
