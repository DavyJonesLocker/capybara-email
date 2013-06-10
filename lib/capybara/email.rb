module Capybara
  module Node
    autoload :Email,    'capybara/node/email'
  end

  module Email
    autoload :DSL,      'capybara/email/dsl'
    autoload :Node,     'capybara/email/node'
    autoload :Driver,   'capybara/email/driver'
    autoload :Version,  'capybara/email/version'
  end
end

if defined?(ActionMailer)
  # Rails 4's ActionMailer::Base is autoloaded
  # so in the test suite the Mail constant is not
  # available untl ActionMailer::Base is eval'd
  # So we must eager-load it
  ActionMailer::Base
end
