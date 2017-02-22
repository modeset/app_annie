require 'spec_helper'

describe AppAnnie::App do
  describe '#initialize' do
    let(:account) { AppAnnie::Account.new({}) }
    let(:raw_hash) do
      {
        "status"=> true,
        "app_name"=>"Test App",
        "app_id"=>"com.testco.TestApp",
        "last_sales_date"=>"2013-12-25",
        "first_sales_date"=>"2012-07-29",
        "icon"=> "https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300"
      }
    end

    it "builds an AppAnnie app from the account and hash data" do
      expect(AppAnnie::App.new(account, raw_hash)).to have_attributes(
        account: account,
        raw: raw_hash,
        id: 'com.testco.TestApp',
        name: 'Test App',
        status: true,
        icon: 'https://lh5.ggpht.com/87Gx7aUL0CajI9b9mLWkFJxcwlCydi_KYxDTZMeyu7nzaDo4MwOA2_8jn8Xz666hUG4=w300',
        first_sales_date: '2012-07-29',
        last_sales_date: '2013-12-25'
      )
    end
  end

  describe 'retrieving a list of sales' do
    let(:account) { AppAnnie::Account.new('account_id' => 123) }
    let(:app) { AppAnnie::App.new(account, {'app_id' => 456})}
    before { allow(AppAnnie).to receive(:connection).and_return(stub_connection) }

    describe 'successfully' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get('/v1/accounts/123/apps/456/sales') {[ 200, {},  "{\"sales_list\":[{\"date\":\"all\",\"country\":\"all\",\"units\":{\"app\":{\"promotions\":0,\"downloads\":128,\"updates\":0,\"refunds\":0},\"iap\":{\"promotions\":0,\"sales\":0,\"refunds\":0}},\"revenue\":{\"app\":{\"promotions\":\"0.00\",\"downloads\":\"0.00\",\"updates\":\"0.00\",\"refunds\":\"0.00\"},\"iap\":{\"promotions\":\"0.00\",\"sales\":\"0.00\",\"refunds\":\"0.00\"},\"ad\":\"0.00\"}}],\"next_page\":null,\"code\":200,\"prev_page\":null,\"page_num\":1,\"iap_sales\":[],\"currency\":\"USD\",\"page_index\":0}" ]}
          end
        end
      end

      it 'returns an array of sales data' do
        result = app.sales
        expect(result.size).to eq(1)
      end
    end

    describe 'when an authorization error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps/456/sales') {[ 401, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { app.sales }.to raise_error(AppAnnie::Unauthorized)
      end
    end

    describe 'when a rate limit error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps/456/sales') {[ 429, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { app.sales }.to raise_error(AppAnnie::RateLimitExceeded)
      end
    end

    describe 'when a server error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps/456/sales') {[ 500, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { app.sales }.to raise_error(AppAnnie::ServerError)
      end
    end

    describe 'when a maintenance error is encountered' do
      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter(:test) { |stub| stub.get('/v1/accounts/123/apps/456/sales') {[ 503, {}, '' ]} }
        end
      end
      it 'raises an exception' do
        expect { app.sales }.to raise_error(AppAnnie::ServerUnavailable)
      end
    end
  end
end
