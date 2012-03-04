class Capybara::Node::Email < Capybara::Node::Document

  def body
    base.raw
  end

  def subject
    base.subject
  end

  def to
    base.to
  end

  def from
    base.from
  end

  def save_and_open
    require 'capybara/util/save_and_open_page'
    ::Capybara.save_and_open_page(body)
  end

end
