require 'capybara/email'

RSpec.configure do |config|
  config.include Capybara::Email::DSL, :type => :feature
  config.include Capybara::Email::DSL, :type => :request
  config.include Capybara::Email::DSL, :type => :acceptance
end
