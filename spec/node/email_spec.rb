# frozen_string_literal: true
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
        expect(email.body).to eq '<a href="http://example.com">example</a>'
      end
    end

    context 'plain' do
      before do
        message.content_type = 'text/plain'
        message.body = 'http://example.com'
      end

      it 'delegates to the base' do
        expect(email.body).to eq 'http://example.com'
      end
    end
  end

  describe '#subject' do
    before do
      message.subject = 'Test subject'
    end

    it 'delegates to the base' do
      expect(email.subject).to eq 'Test subject'
    end

    it 'responds to :subject' do
      expect(email).to respond_to(:subject)
    end
  end

  describe '#to' do
    before do
      message.to = 'test@example.com'
    end

    it 'delegates to the base' do
      expect(email.to).to include 'test@example.com'
    end

    it 'responds to :to' do
      expect(email).to respond_to(:to)
    end
  end

  describe '#reply_to' do
    before do
      message.reply_to = 'test@example.com'
    end

    it 'delegates to the base' do
      expect(email.reply_to).to include 'test@example.com'
    end

    it 'responds to :reply_to' do
      expect(email).to respond_to(:reply_to)
    end
  end

  describe '#from' do
    before do
      message.from = 'test@example.com'
    end

    it 'delegates to the base' do
      expect(email.from).to include 'test@example.com'
    end

    it 'responds to :from' do
      expect(email).to respond_to(:from)
    end
  end

  describe '#header' do
    before do
      message['header-key'] = 'header_value'
    end

    it 'delegates to the base' do
      expect(email.header('header-key')).to eq 'header_value'
    end
  end

  describe '#headers' do
    before do
      message['first-key'] = 'first_value'
      message['second-key'] = 'second_value'
    end

    it 'delegates to the base' do
      expect(email.headers).to include 'first-key'
      expect(email.headers).to include 'second-key'
    end
  end

  describe '#inspect' do
    it 'corrects class name' do
      expect(email.inspect).to eq '<Capybara::Node::Email>'
    end
  end
end
