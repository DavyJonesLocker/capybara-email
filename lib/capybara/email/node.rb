class Capybara::Email::Node < Capybara::Driver::Node
  def text
    native.text
  end

  def [](name)
    string_node[name]
  end

  def value
    string_node.value
  end

  def visible_text
    normalize_whitespace(unnormalized_text)
  end

  def all_text
    normalize_whitespace(text)
  end

  def click(_keys=[], _options={})
    driver.follow(self[:href].to_s)
  end

  def tag_name
    native.node_name
  end

  def visible?
    string_node.visible?
  end

  def disabled?
    string_node.disabled?
  end

  def find(locator)
    native.xpath(locator).map { |node| self.class.new(driver, node) }
  end
  alias :find_xpath :find

  protected

  def unnormalized_text
    if !visible?
      ''
    elsif native.text?
      native.text
    elsif native.element?
      native.children.map do |child|
        Capybara::Email::Node.new(driver, child).unnormalized_text
      end.join
    else
      ''
    end
  end

  private

  def normalize_whitespace(text)
    text.to_s.gsub(/[[:space:]]+/, ' ').strip
  end

  def string_node
    @string_node ||= Capybara::Node::Simple.new(native)
  end
end
