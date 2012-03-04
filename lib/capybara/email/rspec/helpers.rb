module Capybara::Email::RSpecHelpers
  attr_accessor :current_email, :current_emails

  def all_emails
		Mail::TestMailer.deliveries
  end

  def emails_sent_to(recipient)
    self.current_emails = all_emails.select { |email| email.to.include?(recipient) }.map do |email|
      driver = Capybara::Email::Driver.new(email)
      Capybara::Node::Email.new(Capybara.current_session, driver)
    end
  end

  def first_email_sent_to(recipient)
    self.current_email = emails_sent_to(recipient).first
  end
  alias :open_email :first_email_sent_to

  def current_emails
    @current_emails || []
  end

  def clear_emails
    all_emails.clear
    self.current_emails = nil
    self.current_email  = nil
  end
  alias :clear_email :clear_emails
end
