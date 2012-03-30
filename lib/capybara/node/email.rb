class Capybara::Node::Email < Capybara::Node::Document

  # Delegate to the email body
  #
  # @return [Mail::Message#body]
  def body
    base.raw
  end

  # Delegate to the email subject
  #
  # @return [Mail::Message#subject]
  def subject
    base.subject
  end

  # Delegate to the email to
  #
  # @return [Mail::Message#to]
  def to
    base.to
  end

  # Delegate to the email from
  #
  # @return [Mail::Message#from]
  def from
    base.from
  end

  # Will open the email body in your browser
  def save_and_open
    require 'capybara/util/save_and_open_page'
    ::Capybara.save_and_open_page(body)
  end

end
