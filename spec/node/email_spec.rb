require 'spec_helper'

describe Capybara::Node::Email do
  let(:message) { Mail::Message.new }
  let(:email) { Capybara::Node::Email.new(nil, Capybara::Email::Driver.new(message)) }

  describe '#body' do
    context 'html' do
      before do
        message.content_type = 'text/html'
        message.body = '<a href="http://example.com">example</a>'
      end

      it 'delegates to the base' do
        email.body.should eq '<a href="http://example.com">example</a>'
      end
    end

    context 'plain' do
      before do
        message.content_type = 'text/plain'
        message.body = 'http://example.com'
      end

      it 'delegates to the base' do
        email.body.should eq 'http://example.com'
      end
    end
  end

  describe '#subject' do
    before do
      message.subject = 'Test subject'
    end

    it 'delegates to the base' do
      email.subject.should eq 'Test subject'
    end
  end

  describe '#to' do
    before do
      message.to = 'test@example.com'
    end

    it 'delegates to the base' do
      email.to.should include 'test@example.com'
    end
  end

  describe '#from' do
    before do
      message.from = 'test@example.com'
    end

    it 'delegates to the base' do
      email.from.should include 'test@example.com'
    end
  end
end
