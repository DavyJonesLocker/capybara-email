class Capybara::Email::Driver < Capybara::Driver::Base
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def follow(url)
    url = URI.parse(url)
    Capybara.current_session.visit([url.path, url.query].compact.join('?'))
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

  alias_method :find_xpath, :find


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
    if email.mime_type =~ /\Amultipart\/(alternative|related|mixed)\Z/
      if email.html_part
        return email.html_part.body.to_s
      elsif email.text_part
        return email.text_part.body.to_s
      end
    end

    return email.body.to_s
  end

  private

  def convert_to_html(text)
    "<html><body>#{convert_links(text)}</body></html>"
  end

  def convert_links(text)
    text.gsub(%r{(https?://\S+)}, %q{<a href="\1">\1</a>})
  end
end
