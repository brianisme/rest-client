require 'spec_helper'

module RestClient
  describe Middleware do
    let(:subject) { Middleware.new({}, options) }
    let(:options) { { limit: limit, period: period, host: host, id: id } }
    let(:limit) { 1 }
    let(:period) { 1 }
    let(:host) { 'http://www.google.com' }
    let(:id) { 'api_key' }

    it 'creates the key using host and id' do
      expect(subject.send(:key)).to eq "#{host}_#{id}"
    end

    it 'throttles' do
      expect(subject.send(:throttle?)).to eq true
    end

    context 'when not passing limit or period' do
      let(:limit) { nil }
      let(:period) { nil }
      it 'does not throttle' do
        expect(subject.send(:throttle?)).to eq false
      end
    end
  end
end
