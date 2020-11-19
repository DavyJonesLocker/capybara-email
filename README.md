# CapybaraEmail #

[![Build Status](https://travis-ci.org/DavyJonesLocker/capybara-email.svg?branch=master)](https://travis-ci.org/DavyJonesLocker/capybara-email)
[![Code Climate](https://d3s6mut3hikguw.cloudfront.net/github/dockyard/capybara-email.svg)](https://codeclimate.com/github/dockyard/capybara-email)

Easily test [ActionMailer](https://github.com/rails/rails/tree/master/actionmailer) and [Mail](https://github.com/mikel/mail) messages in your Capybara integration tests

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'capybara-email'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-email

## Usage ##

### RSpec ###

In your `spec_helper.rb` require `capybara/email/rspec`.

```ruby
require 'capybara/email/rspec'
```

Example:

```ruby
feature 'Emailer' do
  background do
    # will clear the message queue
    clear_emails
    visit email_trigger_path
    # Will find an email sent to test@example.com
    # and set `current_email`
    open_email('test@example.com')
  end

  scenario 'following a link' do
    current_email.click_link 'your profile'
    expect(page).to have_content 'Profile page'
  end

  scenario 'testing for content' do
    expect(current_email).to have_content 'Hello Joe!'
  end

  scenario 'testing for attachments' do
    expect(current_email.attachments.first.filename).to eq 'filename.csv'
  end

  scenario 'testing for a custom header' do
    expect(current_email.headers).to include 'header-key'
  end

  scenario 'testing for a custom header value' do
    expect(current_email.header('header-key')).to eq 'header_value'
  end

  scenario 'view the email body in your browser' do
    # the `launchy` gem is required
    current_email.save_and_open
  end
end
```

### Cucumber ###
Require `capybara/email` in your `features/support/env.rb`

    require 'capybara/email'

Once you have required `capybara-email`, gaining access to usable methods
is easy as adding this module to your Cucumber `World`:

    World(Capybara::Email::DSL)

I recommend adding this to a support file such as `features/support/capybara_email.rb`

```ruby
require 'capybara/email'
World(Capybara::Email::DSL)
```

Example:

```ruby
Scenario: Email is sent to winning user
  Given "me@example.com" is playing a game
  When that user picks a winning piece
  Then "me@example.com" receives an email with "You've Won!" as the subject

Then /^"([^"]*)" receives an email with "([^"]*)" as the subject$/ do |email_address, subject|
  open_email(email_address)
  expect(current_email.subject).to eq subject
end
```

### Test::Unit ###

Require `capybara/email` at the top of `test/test_helper.rb`

```ruby
  require 'capybara/email'
```

Include `Capybara::Email::DSL` in your test class

```ruby
class ActionDispatch::IntegrationTest
  include Capybara::Email::DSL
end
```

Example:

```ruby
class EmailTriggerControllerTest < ActionDispatch::IntegrationTest
  def setup
    # will clear the message queue
    clear_emails
    visit email_trigger_path

    # Will find an email sent to `test@example.com`
    # and set `current_email`
    open_email('test@example.com')
  end

  test 'testing any email is sent' do
    expect(all_emails).not_to be_empty
  end

  test 'following a link' do
    current_email.click_link 'your profile'
    expect(page).to have_content 'Profile page'
  end

  test 'testing for content' do
    expect(current_email).to have_content 'Hello Joe!'
  end

  test 'testing for a custom header' do
    expect(current_email.headers).to include 'header-key'
  end

  test 'testing for a custom header value' do
    expect(current_email.header('header-key')).to eq 'header_value'
  end

  test 'view the email body in your browser' do
    # the `launchy` gem is required
    current_email.save_and_open
  end
end
```

### CurrentEmail API ###

The `current_email` method will delegate all necessary method calls to
`Mail::Message`. So if you need to access the subject of an email:

```ruby
current_email.subject
```

Check out API for the `mail` gem for details on what methods are
available.

## Setting your test host
When testing, it's common to want to open an email and click through to your
application. To do this, you'll probably need to update your test
environment, as well as Capybara's configuration.

By default, Capybara's `app_host` is set to
`http://example.com.` You should update this so that it points to the
same host as your test environment. In our example, we'll update both to
`http://localhost:3001`:

```ruby
# tests/test_helper.rb
ActionDispatch::IntegrationTest do
  Capybara.server_port = 3001
  Capybara.app_host = 'http://localhost:3001'
end

# config/environments/test.rb
config.action_mailer.default_url_options = { host: 'localhost', 
                                             port: 3001 }
```

## Sending Emails with JavaScript ##
Sending emails asynchronously will cause `#open_email` to not open the
correct email or not find any email at all depending on the state of the
email queue. We recommend forcing a sleep prior to trying to read any
email after an asynchronous event:

```ruby
click_link 'Send email'
sleep 0.1
open_email 'test@example.com'
```

## Authors ##

[Brian Cardarella](http://twitter.com/bcardarella)

[We are very thankful for the many contributors](https://github.com/dockyard/capybara-email/graphs/contributors)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Stable branches are created based upon each minor version. Please make
pull requests to specific branches rather than master.

Please make sure you include tests!

Don't use tabs to indent, two spaces are the standard.

## Legal ##

[DockYard](http://dockyard.com), Inc. &copy; 2014

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
