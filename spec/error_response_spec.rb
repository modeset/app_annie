require 'spec_helper'

describe AppAnnie::ErrorResponse do

  describe '.raise_for' do
    let(:response) { {} }

    before { allow(response).to receive(:body).and_return("{}") }

    describe "401" do
      before { allow(response).to receive(:status).and_return(401) }
      it "should raise Unauthorized" do
        expect do
          AppAnnie::ErrorResponse.raise_for(response)
        end.to raise_error(AppAnnie::Unauthorized)
      end
    end

    describe "429" do
      before { allow(response).to receive(:status).and_return(429) }
      it "should raise RateLimitExceeded" do
        expect do
          AppAnnie::ErrorResponse.raise_for(response)
        end.to raise_error(AppAnnie::RateLimitExceeded)
      end
    end

    describe "500" do
      before { allow(response).to receive(:status).and_return(500) }
      it "should raise ServerError" do
        expect do
          AppAnnie::ErrorResponse.raise_for(response)
        end.to raise_error(AppAnnie::ServerError)
      end
    end

    describe "503" do
      before { allow(response).to receive(:status).and_return(503) }
      it "should raise ServerUnavailable" do
        expect do
          AppAnnie::ErrorResponse.raise_for(response)
        end.to raise_error(AppAnnie::ServerUnavailable)
      end
    end

    describe "other" do
      before { allow(response).to receive(:status).and_return(nil) }
      it "should raise BadResponse" do
        expect do
          AppAnnie::ErrorResponse.raise_for(response)
        end.to raise_error(AppAnnie::BadResponse)
      end
    end

  end

end
