require 'spec_helper'

class TestApp
  def self.call(env)
    [200, {"Content-Type" => "text/plain"}, ["Hello world!"]]
  end
end

feature 'Integration test' do
  background do
    clear_email
    Capybara.app = ::TestApp
  end

  scenario 'html email' do
    email = deliver(html_email)

		open_email('test@example.com')
    current_email.click_link 'example'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a html test'
		
		all_emails.first.should == email
		
		clear_emails()
		all_emails.should be_empty

  end

  scenario 'plain text email' do
    email = deliver(plain_email)

    open_email('test@example.com')
    current_email.click_link 'http://example.com'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a plain test.'

		all_emails.first.should == email
		
		clear_emails()
		all_emails.should be_empty
  end

	scenario 'via ActionMailer' do
		email = deliver(plain_email)

		all_emails.first.should == email

		clear_emails
		all_emails.should be_empty
	end

	scenario 'via Mail' do
		email = plain_email.deliver!

		all_emails.first.should == email
		
		clear_emails
		all_emails.should be_empty
	end
end

def deliver(email)
  ActionMailer::Base.deliveries << email
	email
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
