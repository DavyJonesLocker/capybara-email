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

  def click
    driver.follow(:get, self[:href].to_s)
  end

  def tag_name
    native.node_name
  end

  def visible?
    string_node.visible?
  end

  def find(locator)
    native.xpath(locator).map { |node| self.class.new(driver, node) }
  end

  private

  def string_node
    @string_node ||= Capybara::Node::Simple.new(native)
  end
end
