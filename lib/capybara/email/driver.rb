class Capybara::Email::Driver < Capybara::Driver::Base
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def follow(url)
    url = URI.parse(url)
    host = "#{url.scheme}://#{url.host}"
    host << ":#{url.port}" unless url.port == url.default_port
    host_with_path = File.join(host, url.path)
    Capybara.current_session.visit([host_with_path, url.query].compact.join('?'))
  end

  def body
    dom.to_xml
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

  def find_css(selector)
    dom.css(selector).map { |node| Capybara::Email::Node.new(self, node) }
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

  def method_missing(meth, *args, &block)
    if email.respond_to?(meth)
      if args.empty?
        email.send(meth)
      else
        email.send(meth, args)
      end
    else
      super
    end
  end

  def convert_to_html(text)
    "<html><body>#{convert_links(text)}</body></html>"
  end

  def convert_links(text)
    text.gsub(%r{(https?://\S+)}, %q{<a href="\1">\1</a>})
  end
end
