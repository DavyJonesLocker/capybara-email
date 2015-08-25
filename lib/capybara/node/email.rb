class Capybara::Node::Email < Capybara::Node::Document

  # Delegate to the email body
  #
  # @return [Mail::Message#body]
  def body
    base.raw
  end

  # Treat the message's body as a Capybara::Node::Simple so that
  # selectors actually work instead of raising NotImplementedErrors
  def body_as_simple_node
    @body_as_simple_node ||= Capybara.string base.raw
  end

  # Returns the value of the passed in header key.
  #
  # @return String
  def header(key)
    base.email.header[key].value
  end

  # Returns the header keys as an array of strings.
  #
  # @return [String]
  def headers
    base.email.header.fields.map(&:name)
  end

  # Corrects the inspect string
  #
  # @return [String]
  def inspect
    "<#{self.class.to_s}>"
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

  private

  # Tries to send to `base` first.
  # If an NotImplementedError is hit because some finders/matchers/etc. aren't implemented,
  # fall back to treating the message body as a Capybara::Node::Simple
  def method_missing(meth, *args, &block)
    begin
      base.send(meth, *args)
    rescue NotImplementedError
      body_as_simple_node.send(meth, *args)
    end
  end
end
