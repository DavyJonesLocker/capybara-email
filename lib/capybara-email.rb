require 'capybara'
require 'mail'

if defined?(ActionMailer)
  # Rails 4's ActionMailer::Base is autoloaded
  # so in the test suite the Mail constant is not
  # available untl ActionMailer::Base is eval'd
  # So we must eager-load it
  ActionMailer::Base
end

module Capybara
  autoload :Email, 'capybara/email'
end
