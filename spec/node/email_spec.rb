require 'spec_helper'

describe Capybara::Node::Email do
  let(:message) { mock('Message') }
  let(:email) { Capybara::Node::Email.new(nil, message) }

  describe '#body' do
    before do
      message.stubs(:body).returns('Test message')
    end

    it 'delegates to the base' do
      email.body.should eq 'Test message'
    end
  end

  describe '#subject' do
    before do
      message.stubs(:subject).returns('Test subject')
    end

    it 'delegates to the base' do
      email.subject.should eq 'Test subject'
    end
  end

  describe '#to' do
    before do
      message.stubs(:to).returns(['test@example.com'])
    end

    it 'delegates to the base' do
      email.to.should include 'test@example.com'
    end
  end

  describe '#from' do
    before do
      message.stubs(:from).returns(['test@example.com'])
    end

    it 'delegates to the base' do
      email.from.should include 'test@example.com'
    end
  end
end
