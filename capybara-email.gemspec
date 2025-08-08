# frozen_string_literal: true

require File.expand_path('lib/capybara/email/version', __dir__)

Gem::Specification.new do |gem|
  gem.authors = ['Brian Cardarella']
  gem.email = %w[bcardarella@gmail.com brian@dockyard.com]
  gem.description = 'Test your ActionMailer and Mailer messages in Capybara'
  gem.summary = 'Test your ActionMailer and Mailer messages in Capybara'
  gem.homepage = 'https://github.com/dockyard/capybara-email'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 2.7'

  gem.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md']
  gem.name = 'capybara-email'
  gem.require_paths = ['lib']
  gem.version = Capybara::Email::VERSION

  gem.add_dependency 'capybara', '>= 2.4', '< 4.0'
  gem.add_dependency 'mail'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
