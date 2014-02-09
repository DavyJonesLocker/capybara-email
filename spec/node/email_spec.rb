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

  describe '#reply_to' do
    before do
      message.reply_to = 'test@example.com'
    end

    it 'delegates to the base' do
      email.reply_to.should include 'test@example.com'
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

  describe '#header' do
    before do
      message['header-key'] = 'header_value'
    end

    it 'delegates to the base' do
      email.header('header-key').should eq 'header_value'
    end
  end

  describe '#headers' do
    before do
      message['first-key'] = 'first_value'
      message['second-key'] = 'second_value'
    end

    it 'delegates to the base' do
      email.headers.should include 'first-key'
      email.headers.should include 'second-key'
    end
  end
end
