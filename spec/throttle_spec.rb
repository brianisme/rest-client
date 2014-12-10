require 'spec_helper'
require 'active_support'

module RestClient
  describe Throttle do
    let(:subject) { Throttle.new('key', options) }
    let(:options) { { limit: limit, period: period, store: store } }
    let(:limit) { 5 }
    let(:period) { 2 }
    let(:request_amount) { 1 }

    before do
      limit.times do |i|
        subject.add_request
      end
    end

    context 'when not using CAS' do
      let(:store) { ActiveSupport::Cache::MemoryStore.new }

      context 'when hitting the throttle' do
        let(:request_amount) { limit }

        it 'gets throttled' do
          before_time = Time.now
          subject.add_request
          expect((Time.now - before_time).round).to be period
        end
      end
    end

    context 'when using CAS' do
      let(:store) { RestClient::RedisStore.new(host:'127.0.0.1', port:6379, namespace: 'test') }

      after do
        store.delete('test:key')
      end

      context 'when hitting the throttle' do
        let(:request_amount) { limit }

        it 'gets throttled' do
          before_time = Time.now
          subject.add_request
          expect((Time.now - before_time).round).to be period
        end
      end
    end
  end
end
