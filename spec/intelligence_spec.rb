require 'spec_helper'

describe AppAnnie::Intelligence do

  describe '.top_app_charts' do

    describe 'make an api query' do

      describe 'with missing options' do
        it 'should thrown an error' do
          expect { AppAnnie::Intelligence.top_app_charts({}) }.to raise_error(ArgumentError)
        end
      end

      describe 'successfully' do
        let(:options) { {market: 'ios', device: 'iphone', categories: 'Overall > Business'} }
        let(:mock_resp_file) { File.expand_path("../api_fixtures/intelligence_top_charts.json", __FILE__) }
        let(:stub_connection) do
          Faraday.new do |builder|
            builder.adapter :test do |stub|
              stub.get("/v1.1/intelligence/apps/#{options[:market]}/ranking") {[ 200, {},  File.read(mock_resp_file)]}
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
end
