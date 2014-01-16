module AppAnnie
  class Account

    attr_reader :raw,
                :id,
                :name,
                :status,
                :platform,
                :first_sales_date,
                :last_sales_date,
                :publisher_name

    def initialize(attributes)
      @raw = attributes
      @id = attributes['account_id']
      @name = attributes['account_name']
      @status = attributes['account_status']
      @platform = attributes['platform']
      @publisher_name = attributes['publisher_name']
      @first_sales_date = attributes['first_sales_date']
      @last_sales_date = attributes['last_sales_date']
    end

    def apps(options = {})
      response = AppAnnie.connection.get do |req|
        req.headers['Authorization'] = "Bearer #{AppAnnie.api_key}"
        req.headers['Accept'] = 'application/json'
        req.url "/v1/accounts/#{id}/apps", options
      end

      case response.status
      when 200 then return JSON.parse(response.body)['app_list'].map { |hash| App.new(self, hash) }
      when 401 then raise Unauthorized, "Invalid API key - set an env var for APPANNIE_API_KEY or set AppAnnie.api_key manually"
      when 429 then raise RateLimitExceeded
      when 500 then raise ServerError
      when 503 then raise ServerUnavailable
      else raise BadResponse, "An error occurred. Response code: #{response.status}"
      end
    end

    def sales(options = {})
      response = AppAnnie.connection.get do |req|
        req.headers['Authorization'] = "Bearer #{AppAnnie.api_key}"
        req.headers['Accept'] = 'application/json'
        req.url "/v1/accounts/#{id}/sales", options
      end

      case response.status
      when 200 then return JSON.parse(response.body)['sales_list']
      when 401 then raise Unauthorized, "Invalid API key - set an env var for APPANNIE_API_KEY or set AppAnnie.api_key manually"
      when 429 then raise RateLimitExceeded
      when 500 then raise ServerError
      when 503 then raise ServerUnavailable
      else raise BadResponse, "An error occurred. Response code: #{response.status}"
      end
    end

  end
end
