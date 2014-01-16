module AppAnnie
  class App

    attr_reader :raw,
                :account,
                :id,
                :account_id,
                :status,
                :name,
                :first_sales_date,
                :last_sales_date,
                :icon

    def initialize(account, attributes)
      @raw = attributes
      @account = account
      @id = attributes['app_id']
      @name = attributes['app_name']
      @status = attributes['status']
      @icon = attributes['icon']
      @first_sales_date = attributes['first_sales_date']
      @last_sales_date = attributes['last_sales_date']
    end

    def sales(breakdown = nil)
      response = AppAnnie.connection.get do |req|
        req.headers['Authorization'] = "Bearer #{AppAnnie.api_key}"
        req.headers['Accept'] = 'application/json'
        req.url "/v1/accounts/#{@account.id}/apps/#{@id}/sales", break_down: breakdown
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
