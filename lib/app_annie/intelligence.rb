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

      if response.status == 200
        JSON.parse(response.body)['list']
      else
        ErrorResponse.raise_for(response)
      end
    end
  end
end
