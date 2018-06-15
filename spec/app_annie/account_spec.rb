require 'spec_helper'

describe AppAnnie::Account do
  describe 'building an account from a hash' do
    it "parses the hash" do
      raw_hash = {
        "account_id"=>110000,
        "platform"=>"ITC",
        "last_sales_date"=>"2014-01-05",
        "account_status"=>"OK",
        "first_sales_date"=>"2013-12-07",
        "publisher_name"=>"AppCo",
        "account_name"=>"AppCo iTunes"
      }

      expect(AppAnnie::Account.new(raw_hash)).to have_attributes(
        raw: raw_hash,
        id: 110000,
        name: 'AppCo iTunes',
        status: 'OK',
        platform: 'ITC',
        first_sales_date: '2013-12-07',
        last_sales_date: '2014-01-05',
        publisher_name: 'AppCo'
      )
    end
  end

  describe 'retrieving a list of apps' do
    let(:account) { AppAnnie::Account.new('account_id' => 123) }
    before { allow(AppAnnie).to receive(:connection).and_return(stub_connection) }

    describe 'successfully' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get('/v1/accounts/123/apps') {[ 200, {}, "{\"page_index\":0,\"code\":200,\"app_list\":[{\"status\":true,\"app_name\":\"Test App\",\"app_id\":\"com.testco.TestApp\",\"last_sales_date\":\"2013-12-25\",\"first_sales_date\":\"2012-07-29\",\"icon\":\"https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300\"}],\"prev_page\":null,\"page_num\":1,\"next_page\":null}" ]}
          end
        end
      end

      it 'returns an array of AppAnnie::App objects' do
        result = account.apps
        expect(result.size).to eq(1)
        expect(result.first.class).to be(AppAnnie::App)
      end

      it 'sets properties appropriately from the response' do
        app = account.apps.first
        expect(app.account).to be(account)
        expect(app.status).to eq(true)
        expect(app.name).to eq('Test App')
        expect(app.id).to eq('com.testco.TestApp')
        expect(app.last_sales_date).to eq('2013-12-25')
        expect(app.first_sales_date).to eq('2012-07-29')
        expect(app.icon).to eq('https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300')
      end

    end

    describe 'when an authorization error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps') {[ 401, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { account.apps }.to raise_error(AppAnnie::Unauthorized)
      end
    end

    describe 'when a rate limit error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps') {[ 429, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { account.apps }.to raise_error(AppAnnie::RateLimitExceeded)
      end
    end

    describe 'when a server error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps') {[ 500, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { account.apps }.to raise_error(AppAnnie::ServerError)
      end
    end

    describe 'when a maintenance error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps') {[ 503, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { account.apps }.to raise_error(AppAnnie::ServerUnavailable)
      end
    end
  end
end
