module CapybaraHelpers
  def assert_no_link_for(text)
    page.should_not(have_css("a", :text => text),
      "Expected to not see the #{text.inspect} link, but did.")
  end

  def assert_link_for(text)
    page.should(have_css("a", :text => text),
      "Expected to see the #{text.inspect} link, but did not.")
  end

  def state_line_for(state)
    state = State.find_by_name!(state)
    "#state_#{state.id}"
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, :type => :feature
end
