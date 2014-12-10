require 'spec_helper'

module RestClient
  describe RedisStore do
    let(:subject) { RedisStore.new(namespace: namespace) }
    let(:namespace) { 'inspectest' }

    context 'when given a namespace' do
      context 'when given a single key' do
        let(:key) { 'key' }
        it 'namespaced a single key' do
          expect(subject.namespaced_key(key)).to eq "#{namespace}:#{key}"
        end
      end

      context 'when given a list of keys' do
        let(:keys) { ['key', 'key2', 'key3'] }

        it 'namespaced a list of keys' do
          expect(subject.namespaced_key(keys)).to eq(keys.map { |k| "#{namespace}:#{k}" })
        end
      end

    end
  end
end
