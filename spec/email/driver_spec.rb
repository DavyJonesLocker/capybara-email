require 'spec_helper'

feature 'Integration test' do
  background do
    clear_email
    Capybara.app = TestApp
  end

  scenario 'html email' do
    deliver(html_email)
    open_email('test@example.com')
    current_email.click_link 'example'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a html test'
  end

  scenario 'plain text email' do
    deliver(plain_email)
    open_email('test@example.com')
    current_email.click_link 'http://example.com'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a plain test.'
  end
end

class TestApp
  def self.call(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
  end
end

def deliver(email)
  ActionMailer::Base.deliveries << email
end

def html_email
  Mail::Message.new(:body => <<-HTML, :content_type => 'text/html', :to => 'test@example.com')
<html>
  <body>
    <p>
      This is only a html test.
      <a href="http://example.com">example</a>
    </p>
  </body>
</html>
  HTML
end

def plain_email
  Mail::Message.new(:body => <<-PLAIN, :content_type => 'text/plain', :to => 'test@example.com')
This is only a plain test.
http://example.com
  PLAIN
end
