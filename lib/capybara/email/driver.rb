class Capybara::Email::Driver < Capybara::Driver::Base
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def follow(method, path, attributes = {})
    Capybara.current_session.driver.follow(method, path, attributes)
  end

  def body
    dom.to_xml
  end

  def dom
    @dom ||= Nokogiri::HTML(source)
  end

  def find(selector)
    dom.xpath(selector).map { |node| Capybara::Email::Node.new(self, node) }
  end

  def source
    if email.mime_type == 'text/plain'
      convert_to_html(email.body.encoded)
    else
      email.body.encoded
    end
  end

  private

  def convert_to_html(text)
    "<html><body>#{convert_links(text)}</body></html>"
  end

  def convert_links(text)
    text.gsub(%r{(https?://\S+)}, %q{<a href="\1">\1</a>})
  end
end
