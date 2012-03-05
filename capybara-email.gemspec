# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capybara/email/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Brian Cardarella']
  gem.email         = ['bcardarella@gmail.com', 'brian@dockyard.com']
  gem.description   = %q{Test your ActionMailer and Mailer messages in Capybara}
  gem.summary       = %q{Test your ActionMailer and Mailer messages in Capybara}
  gem.homepage      = 'https://github.com/dockyard/capybara-email'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.name          = 'capybara-email'
  gem.require_paths = ['lib']
  gem.version       = Capybara::Email::VERSION

  gem.add_development_dependency 'mail'
  gem.add_development_dependency 'actionmailer'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'bourne'
  gem.add_development_dependency 'rspec'
end
