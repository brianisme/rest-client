require 'spec_helper'

module RestClient
  describe Client do
    let(:subject) { RestClient::Client.new('http://www.google.com') }

    it 'should make the request', vcr: {cassette_name: 'get-google', allow_unused_http_interactions: false} do
      expect {subject.get('')}.to_not raise_error
    end
  end
end
