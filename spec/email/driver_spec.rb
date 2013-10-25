require 'spec_helper'

class TestApp
  def self.call(env)
    [200, {'Content-Type' => 'text/plain'}, ['Hello world!']]
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

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  scenario 'html email follows links' do
    email = deliver(html_email)
    open_email('test@example.com')

    current_email.click_link 'example'
    page.current_url.should eq('http://example.com/')

    current_email.click_link 'another example'
    page.current_url.should eq('http://example.com:1234/')

    current_email.click_link 'yet another example'
    page.current_url.should eq('http://example.com:1234/some/path?foo=bar')
  end

  scenario 'plain text email' do
    email = deliver(plain_email)

    open_email('test@example.com')
    current_email.click_link 'http://example.com'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a plain test.'

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  # should read html_part
  scenario 'multipart email' do
    email = deliver(multipart_email)

    open_email('test@example.com')
    current_email.click_link 'example'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a html test'

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  # should read html_part
  scenario 'multipart/related email' do
    email = deliver(multipart_related_email)

    open_email('test@example.com')
    current_email.click_link 'example'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a html test'

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  # should read html_part
  scenario 'multipart/mixed email' do
    email = deliver(multipart_mixed_email)

    open_email('test@example.com')
    current_email.click_link 'example'
    page.should have_content 'Hello world!'
    current_email.should have_content 'This is only a html test'

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  scenario 'via ActionMailer' do
    email = deliver(plain_email)

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  scenario 'via Mail' do
    email = plain_email.deliver!

    all_emails.first.should eq email

    clear_emails
    all_emails.should be_empty
  end

  scenario 'multiple emails' do
    deliver(plain_email)
    deliver(Mail::Message.new(:to => 'test@example.com', :body => 'New Message', :context => 'text/plain'))
    open_email('test@example.com')
    current_email.body.should eq 'New Message'
  end

  scenario "cc'd" do
    deliver(Mail::Message.new(:cc => 'test@example.com', :body => 'New Message', :context => 'text/plain'))
    open_email('test@example.com')
    current_email.body.should eq 'New Message'
  end

  scenario "bcc'd" do
    deliver(Mail::Message.new(:bcc => 'test@example.com', :body => 'New Message', :context => 'text/plain'))
    open_email('test@example.com')
    current_email.body.should eq 'New Message'
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
      <a href="http://example.com:1234">another example</a>
      <a href="http://example.com:1234/some/path?foo=bar">yet another example</a>
    </p>
  </body>
</html>
  HTML
end

def plain_email
  Mail::Message.new(:body => <<-PLAIN, :content_type => 'text/plain', :to => 'test@example.com', :from => 'sender@example.com')
This is only a plain test.
http://example.com
  PLAIN
end

def multipart_email
  Mail::Message.new do
    to 'test@example.com'
    text_part do
      body plain_email.body.encoded
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body html_email.body.encoded
    end
  end
end

def multipart_related_email
  Mail::Message.new do
    to 'test@example.com'
    text_part do
      body plain_email.body.encoded
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body html_email.body.encoded
    end
    content_type 'multipart/related; charset=UTF-8'
  end
end

def multipart_mixed_email
  Mail::Message.new do
    to 'test@example.com'
    text_part do
      body plain_email.body.encoded
    end
    html_part do
      content_type 'text/html; charset=UTF-8'
      body html_email.body.encoded
    end
    content_type 'multipart/mixed; charset=UTF-8'
  end
end
