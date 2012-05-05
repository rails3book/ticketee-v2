require 'spec_helper'

feature "Viewing tickets" do
  before do
    textmate_2 = Factory(:project, :name => "TextMate 2")
    user = Factory(:confirmed_user)
    ticket = Factory(:ticket,
                     :project => textmate_2,
                     :title => "Make it shiny!",
                     :description => "Gradients! Starbursts! Oh my!")
    ticket.update_attribute(:user, user)

    internet_explorer = Factory(:project, :name => "Internet Explorer")
    Factory(:ticket,
            :project => internet_explorer,
            :title => "Standards compliance",
            :description => "Isn't a joke.")

    define_permission!(user, "view", textmate_2)
    define_permission!(user, "view", internet_explorer)
    sign_in_as!(user)

    visit '/'
  end

  scenario "Viewing tickets for a given project" do
    click_link "TextMate 2"
    page.should have_content("Make it shiny!")
    page.should_not have_content("Standards compliance")

    click_link "Make it shiny!"
    within("#ticket h2") do
      page.should have_content("Make it shiny!")
    end
    page.should have_content("Gradients! Starbursts! Oh my!")
  end
end
