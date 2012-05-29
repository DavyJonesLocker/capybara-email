class Capybara::Email::Driver < Capybara::Driver::Base
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def follow(url)
    url = URI.parse(url)
    url = case Capybara.current_driver
    when :rack_test
      url.to_s
    else
      Capybara.current_session.driver.send(:url, url.request_uri)
    end

    Capybara.current_session.driver.visit url
  end


  def body
    dom.to_xml
  end

  # Access to email subject
  #
  #  delegates back to instance of Mail::Message
  #
  # @return String
  def subject
    email.subject
  end

  # Access to email recipient(s)
  #
  #  delegates back to instance of Mail::Message
  #
  # @return [Array<String>]
  def to
    email.to
  end

  # Access to email sender(s)
  #
  #  delegates back to instance of Mail::Message
  #
  # @return [Array<String>]
  def from
    email.from
  end

  # Nokogiri object for traversing content
  #
  # @return Nokogiri::HTML::Document
  def dom
    @dom ||= Nokogiri::HTML(source)
  end

  # Find elements based on given xpath
  #
  # @param [xpath string]
  #
  # @return [Array<Capybara::Driver::Node>]
  def find(selector)
    dom.xpath(selector).map { |node| Capybara::Email::Node.new(self, node) }
  end

  # String version of email HTML source
  #
  # @return String
  def source
    if email.mime_type == 'text/plain'
      convert_to_html(raw)
    else
      raw
    end
  end

  # Plain text email contents
  #
  # @return String
  def raw
    email.body.encoded
  end

  private

  def convert_to_html(text)
    "<html><body>#{convert_links(text)}</body></html>"
  end

  def convert_links(text)
    text.gsub(%r{(https?://\S+)}, %q{<a href="\1">\1</a>})
  end
end
