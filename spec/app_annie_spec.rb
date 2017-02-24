require 'spec_helper'

describe AppAnnie do

  it 'has a version number' do
    expect(AppAnnie::VERSION).not_to be_nil
  end

  describe 'setting the API key' do
    before { AppAnnie.instance_variable_set('@api_key', nil) }

    it 'allows the api_key to be set directly' do
      AppAnnie.api_key = 'abc123'
      expect(AppAnnie.api_key).to eq('abc123')
    end

    it 'allows the api_key to be set via the APPANNIE_API_KEY environment variable' do
      ENV['APPANNIE_API_KEY'] = 'def456'
      expect(AppAnnie.api_key).to eq('def456')
    end

  end

  describe 'fetching a list of accounts' do
    before { allow(AppAnnie).to receive(:connection).and_return(stub_connection) }

    describe 'successfully' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get('/v1/accounts') {[ 200, {}, "{\"page_index\":0,\"code\":200,\"account_list\":[{\"account_id\":110000,\"platform\":\"GP\",\"last_sales_date\":\"2014-01-05\",\"account_status\":\"OK\",\"first_sales_date\":\"2012-06-15\",\"publisher_name\":\"AppCo\",\"account_name\":\"AppCo ITC\"}],\"prev_page\":null,\"page_num\":1,\"next_page\":null}" ]}
          end
        end
      end

      it 'returns an array of AppAnnie::Account objects' do
        result = AppAnnie.accounts
        expect(result.size).to eq(1)
        expect(result.first.class).to be(AppAnnie::Account)
      end

    end

    describe 'when an authorization error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts') {[ 401, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { AppAnnie.accounts }.to raise_error(AppAnnie::Unauthorized)
      end
    end

    describe 'when a rate limit error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts') {[ 429, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { AppAnnie.accounts }.to raise_error(AppAnnie::RateLimitExceeded)
      end
    end

    describe 'when a server error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts') {[ 500, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { AppAnnie.accounts }.to raise_error(AppAnnie::ServerError)
      end
    end

    describe 'when a maintenance error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts') {[ 503, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { AppAnnie.accounts }.to raise_error(AppAnnie::ServerUnavailable)
      end
    end

  end

end
