require 'rubygems'
require 'bundler/setup'

begin
  require 'byebug'
rescue LoadError
end

RSpec.configure do |config|
  config.mock_with :mocha
end

require 'mail'
require 'bourne'
require 'action_mailer'
require 'capybara/rspec'
require 'capybara/email/rspec'

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.mock_with :mocha
end
