require "spec_helper"

describe AppAnnie::MetaData do
  describe ".translate_ids" do
    context "with missing options" do
      it "raises an error" do
        expect { AppAnnie::MetaData.translate_ids({}) }.
          to raise_error(ArgumentError, /Missing/)
      end
    end

    it "returns the parsed results" do
      market = "google-play"
      codes = ["com.example.app"]
      path = "/v1.2/apps/#{market}/package-codes2ids?"\
             "package_codes=#{codes.join(',')}"

      stubbed_connection = stub_connection(path, app_history_payload)
      allow(AppAnnie).to receive(:connection).and_return(stubbed_connection)

      results = AppAnnie::MetaData.translate_ids(
        market: market,
        package_codes: codes,
      )

      expect(results).to eq(
        "items" => [
          {
            "package_code" => "com.example.app",
            "product_id" => 12345000054321,
          },
        ],
        "code" => 200,
      )
    end

    def stub_connection(path, payload)
      Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get(path) { [200, {}, payload] }
        end
      end
    end

    def app_history_payload
      File.read(
        File.expand_path(
          "../../api_fixtures/meta_data_translate_ids.json",
          __FILE__,
        ),
      )
    end
  end
end
