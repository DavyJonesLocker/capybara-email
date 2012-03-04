require 'rspec'
require 'action_mailer'
require 'capybara/rspec'
require 'capybara/email/rspec'
require 'capybara/spec/driver'
require 'bourne'

RSpec.configure do |config|
  config.mock_with :mocha
end
