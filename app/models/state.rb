class State < ActiveRecord::Base
  attr_accessible :background, :color, :name

  def to_s
    name
  end
end
