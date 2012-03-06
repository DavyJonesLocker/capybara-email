require 'capybara/email'

RSpec.configure do |config|
  config.include Capybara::Email::DSL
end
