module Capybara::Email::DSL

  # Returns the currently set email.
  # If no email set will return nil.
  #
  # @return [Mail::Message, nil]
  attr_accessor :current_email
  attr_accessor :current_emails

  # Access all emails
  #
  # @return [Array]
  def all_emails
    Mail::TestMailer.deliveries
  end

  # Access all emails with a subject
  #
  # @param [String]
  #
  # @return [Array<Mail::Message>]
  def emails_sent_with_subject(subject)
    self.current_emails = all_emails.select { |email| email.subject == subject }.map do |email|
      driver = Capybara::Email::Driver.new(email)
      Capybara::Node::Email.new(Capybara.current_session, driver)
    end
  end

  # Access all emails for a recipient.
  #
  # @param [String]
  #
  # @return [Array<Mail::Message>]
  def emails_sent_to(recipient)
    self.current_emails = all_emails.select { |email| [email.to, email.cc, email.bcc].flatten.compact.include?(recipient) }.map do |email|
      driver = Capybara::Email::Driver.new(email)
      Capybara::Node::Email.new(Capybara.current_session, driver)
    end
  end

  # Access the first email with a subject and set it to current_email.
  #
  # @param [String]
  #
  # @return [Mail::Message]
  def first_email_sent_with_subject(subject)
    self.current_email = emails_sent_with_subject(subject).last
  end

  # Access the first email for a recipient and set it to current_email.
  #
  # @param [String]
  #
  # @return [Mail::Message]
  def first_email_sent_to(recipient)
    self.current_email = emails_sent_to(recipient).last
  end

  # Open an email
  #
  def open_email(selector)
    first_email_sent_to(selector) || first_email_sent_with_subject(selector)
  end

  # Returns a collection of all current emails retrieved
  #
  # @return [Array<Mail::Message>]
  def current_emails
    @current_emails || []
  end

  # Clear the email queue
  def clear_emails
    all_emails.clear
    self.current_emails = nil
    self.current_email  = nil
  end
  alias :clear_email :clear_emails
end
