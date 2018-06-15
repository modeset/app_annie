require 'spec_helper'

describe AppAnnie::Intelligence do
  describe '.app_history' do
    describe 'make an api query' do
      describe 'with missing options' do
        it 'should thrown an error' do
          expect { AppAnnie::Intelligence.app_history({}) }.
            to raise_error(ArgumentError)
        end
      end

      describe 'successfully' do
        it 'should return results' do
          options = {
            app_id: '123456',
            countries: 'US',
            feeds: 'downloads',
            market: 'ios',
          }
          path = "/v1.2/intelligence/apps/ios/app/#{options[:app_id]}/history"
          stubbed_connection = stub_connection(path, app_history_payload)
          allow(AppAnnie).to receive(:connection).and_return(stubbed_connection)

          result = AppAnnie::Intelligence.app_history(options)

          expect(result).to match(a_hash_including({
            "vertical" => "apps",
            "market" => "ios",
            "currency" => "",
            "code" => 200,
            "product_id" => 1,
            "product_name" => "Demo app one",
            "granularity" => "daily",
            "list" => kind_of(Array),
          }))
        end
      end
    end

    def app_history_payload
      File.read(
        File.expand_path(
          "../../api_fixtures/intelligence_app_history.json",
          __FILE__,
        ),
      )
    end
  end

  describe ".app_usage_history" do
    describe "make an api query" do
      describe "with missing options" do
        it "should throw an error" do
          expect { AppAnnie::Intelligence.app_usage_history({}) }.
            to raise_error(ArgumentError)
        end
      end

      describe "successfully" do
        it "returns results" do
          options = {
            app_id: "54321",
            device: "iphone",
            countries: "WW",
            granularity: "weekly",
            market: "ios",
            start_date: "2018-05-27",
          }
          path = "/v1.2/intelligence/apps/#{options[:market]}/app/"\
            "#{options[:app_id]}/usage-history?countries=#{options[:countries]}"\
            "&device=#{options[:device]}&granularity=#{options[:granularity]}"\
            "&start_date=#{options[:start_date]}"
          stubbed_connection = stub_connection(path, app_usage_history_payload)
          allow(AppAnnie).to receive(:connection).and_return(stubbed_connection)

          result = AppAnnie::Intelligence.app_usage_history(options)

          expect(result).to match(a_hash_including({
            "vertical" => "apps",
            "market" => "ios",
            "code" => 200,
            "product_id" => 54321,
            "product_name" => "ExampleCompanyApp",
            "granularity" => "weekly",
            "list" => kind_of(Array),
          }))
        end
      end
    end

    def app_usage_history_payload
      File.read(
        File.expand_path(
          "../../api_fixtures/intelligence_app_usage_history.json",
          __FILE__,
        ),
      )
    end
  end

  describe '.top_app_charts' do
    describe 'make an api query' do
      describe 'with missing options' do
        it 'should thrown an error' do
          expect { AppAnnie::Intelligence.top_app_charts({}) }.to raise_error(ArgumentError)
        end
      end

      describe 'successfully' do
        let(:options) { {market: 'ios', device: 'iphone', categories: 'Overall > Business'} }
        let(:mock_resp_file) { File.expand_path("../../api_fixtures/intelligence_top_charts.json", __FILE__) }
        let(:stub_connection) do
          Faraday.new do |builder|
            builder.adapter :test do |stub|
              stub.get("/v1.2/intelligence/apps/#{options[:market]}/ranking") {[ 200, {},  File.read(mock_resp_file)]}
            end
          end
        end

        before { allow(AppAnnie).to receive(:connection).and_return(stub_connection) }

        it 'should return results' do
          expect(AppAnnie::Intelligence.top_app_charts(options)).to be_an(Array)
        end
      end
    end
  end

  def stub_connection(path, payload)
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get(path) { [200, {}, payload] }
      end
    end
  end
end
