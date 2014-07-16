require 'faraday'
require 'json'
require 'app_annie/account'
require 'app_annie/app'
require 'app_annie/intelligence'
require 'app_annie/version'

module AppAnnie

  class << self

    attr_writer :api_key

    def api_key
      @api_key || ENV['APPANNIE_API_KEY']
    end

  end

  def self.accounts(options = {})
    response = connection.get do |req|
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.headers['Accept'] = 'application/json'
      req.url '/v1/accounts', options
    end

    case response.status
    when 200 then return JSON.parse(response.body)['account_list'].map { |hash| Account.new(hash) }
    when 401 then raise Unauthorized, "Invalid API key - set an env var for APPANNIE_API_KEY or set AppAnnie.api_key manually"
    when 429 then raise RateLimitExceeded
    when 500 then raise ServerError
    when 503 then raise ServerUnavailable
    else raise BadResponse, "An error occurred. Response code: #{response.status}"
    end
  end

  def self.connection
    @connection ||= Faraday.new url: 'https://api.appannie.com' do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  class Unauthorized < Exception; end
  class RateLimitExceeded < Exception; end
  class ServerError < Exception; end
  class ServerUnavailable < Exception; end

end
