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

