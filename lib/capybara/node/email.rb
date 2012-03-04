class Capybara::Node::Email < Capybara::Node::Document

  def body
    base.body
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

end
