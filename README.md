# CapybaraEmail #

Easy test your ActionMail emails in your Capybara integration tests

## Installation ##

Add this line to your application's Gemfile:

    gem 'capybara-email'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-email

## Usage ##

```ruby
# rspec example

feature 'Emailer' do
  background do
    # will clear the ActionMailer queue
    clear_emails
    visit email_trigger_path
  end

  scenario 'following a link' do
    open_email('test@example.com')
    current_email.click_link 'your profile'
    page.should have_content 'Profile page'
  end

  scenario 'testing for content' do
    open_email('test@example.com')
    current_email.should have_content 'Hello Joe!'
  end
end
```

## Authors ##

[Brian Cardarella](http://twitter.com/bcardarella)

## Versioning ##

This gem follows [Semantic Versioning](http://semver.org)

## Want to help? ##

Stable branches are created based upon each minor version. Please make
pull requests to specific branches rather than master.

Please make sure you include tests!

Unles Rails drops support for Ruby 1.8.7 we will continue to use the
hash-rocket syntax. Please respect this.

Don't use tabs to indent, two spaces are the standard.

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2012

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
