source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'dynamic_form', '1.1.4'
gem 'devise', '2.2.4'
gem 'cancan', '1.6.10'
gem 'paperclip', '3.4.2'
gem 'searcher', :git => "git://github.com/radar/searcher"

group :assets do
  gem 'sass-rails', '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'

  gem 'uglifier', '>= 2.1.1'
end

gem 'jquery-rails'
gem 'debugger'

group :test, :development do
  gem 'gmail', '0.4.0'
  gem 'rspec-rails', '~> 2.13.2'
  gem 'sqlite3'
end

group :development do
  gem 'capistrano'
end

group :test do
  gem 'capybara', '~> 2.1.0'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'email_spec', '~> 1.4.0'
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'therubyracer'
  gem 'pg'
end
