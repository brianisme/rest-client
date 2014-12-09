require 'spec_helper'

module RestClient
  describe Throttle do
    let(:subject) { Throttle.new('key', options) }
    let(:options) { { limit: limit, period: period, store: store } }
    let(:limit) { 5 }
    let(:period) { 2 }
    let(:store) { ActiveSupport::Cache::MemoryStore.new }

    context 'when hitting the throttle' do

      before do
        limit.times do
          subject.add_request
        end
      end

      it 'raises an exception' do
        before_time = Time.now
        subject.add_request
        expect((Time.now - before_time).round).to be period
      end
    end
  end
end
