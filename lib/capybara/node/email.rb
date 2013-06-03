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

  # Delegate to the email reply_to
  #
  # @return [Mail::Message#reply_to]
  def reply_to
    base.email.reply_to
  end

  # Delegate to the email from
  #
  # @return [Mail::Message#from]
  def from
    base.from
  end

  # Save a snapshot of the page.
  #
  # @param  [String] path     The path to where it should be saved [optional]
  #
  def save_page(path = nil)
    path ||= "capybara-email-#{Time.new.strftime("%Y%m%d%H%M%S")}#{rand(10**10)}.html"
    path = File.expand_path(path, Capybara.save_and_open_page_path) if Capybara.save_and_open_page_path

    FileUtils.mkdir_p(File.dirname(path))

    File.open(path,'w') { |f| f.write(body) }
    path
  end

  # Save a snapshot of the page and open it in a browser for inspection
  #
  # @param  [String] path     The path to where it should be saved [optional]
  #
  def save_and_open(file_name = nil)
    require 'launchy'
    Launchy.open(save_page(file_name))
  rescue LoadError
    warn 'Please install the launchy gem to open page with save_and_open_page'
  end
end
