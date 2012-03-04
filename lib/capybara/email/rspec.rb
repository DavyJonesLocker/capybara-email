require 'capybara/email'
require 'capybara/email/rspec/helpers'

RSpec.configure do |config|
  config.include Capybara::Email::RSpecHelpers, :type => :request
  config.include Capybara::Email::RSpecHelpers, :type => :acceptance
end
