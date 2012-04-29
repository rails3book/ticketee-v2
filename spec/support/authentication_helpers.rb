module AuthenticationHelpers
  def sign_in_as!(user)
    visit '/users/sign_in'
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button 'Sign in'
    page.should have_content("Signed in successfully.")
  end
end

RSpec.configure do |c|
  c.include AuthenticationHelpers, :type => :request
end
