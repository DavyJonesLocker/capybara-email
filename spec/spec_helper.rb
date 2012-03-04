require 'rspec'
require 'mail'
require 'bourne'
require 'action_mailer'
require 'capybara/rspec'
require 'capybara/email/rspec'
require 'capybara/spec/driver'

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.mock_with :mocha
end
