module AppAnnie
  class Intelligence
    # see AppAnnie Intelligence docs for options
    # all ops get passed as query params
    def self.top_app_charts(opts)
      [:market, :device, :categories].each do |key|
        unless opts.keys.include?(key)
          raise ArgumentError, "Missing #{key} key in options"
        end
      end
      default_options = {
        vertical: 'apps',
        countries: 'US',
      }
      opts = default_options.merge(opts)

      response = AppAnnie.connection.get do |req|
        req.headers['Authorization'] = "Bearer #{AppAnnie.api_key}"
        req.headers['Accept'] = 'application/json'
        req.url "/v1.1/intelligence/#{opts[:vertical]}/#{opts[:market]}/ranking"
        req.params = opts
      end
      case response.status
      when 200 then return JSON.parse(response.body)['list']
      when 401 then raise Unauthorized, "Invalid API key - set an env var for APPANNIE_API_KEY\
                                          or set AppAnnie.api_key manually"
      when 429 then raise RateLimitExceeded
      when 500 then raise ServerError
      when 503 then raise ServerUnavailable
      else raise BadResponse, "An error occurred. Response code: #{response.status}"
      end
    end
  end
end
