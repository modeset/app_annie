module AppAnnie
  class Intelligence
    API_ROOT = "/v1.2/intelligence".freeze

    def self.app_history(opts)
      [
        :app_id,
        :countries,
        :feeds,
        :market,
      ].each do |key|
        unless opts.keys.include?(key)
          raise ArgumentError, "Missing #{key} key in options"
        end
      end

      default_options = {
        vertical: 'apps',
      }
      opts = default_options.merge(opts)

      response = AppAnnie.connection.get do |req|
        req.headers['Authorization'] = "Bearer #{AppAnnie.api_key}"
        req.headers['Accept'] = 'application/json'
        req.url(
          "#{API_ROOT}/#{opts[:vertical]}/#{opts[:market]}/"\
          "app/#{opts[:app_id]}/history"
        )
        req.params = opts
      end

      if response.status == 200
        JSON.parse(response.body)
      else
        ErrorResponse.raise_for(response)
      end
    end

    def self.app_usage_history(opts)
      [
        :app_id,
        :countries,
        :market,
      ].each do |key|
        unless opts.keys.include?(key)
          raise ArgumentError, "Missing #{key} key in options"
        end
      end

      default_options = {
        vertical: "apps",
        device: "all",
      }
      opts = default_options.merge(opts)

      response = AppAnnie.connection.get do |req|
        req.headers["Authorization"] = "Bearer #{AppAnnie.api_key}"
        req.headers["Accept"] = "application/json"
        req.url(
          "#{API_ROOT}/#{opts[:vertical]}/#{opts[:market]}/app/"\
            "#{opts[:app_id]}/usage-history"
        )
        req.params = opts
      end

      if response.status == 200
        JSON.parse(response.body)
      else
        ErrorResponse.raise_for(response)
      end
    end

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
        req.url "#{API_ROOT}/#{opts[:vertical]}/#{opts[:market]}/ranking"
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
