module AppAnnie
  class MetaData
    API_ROOT = "/v1.2/".freeze

    def self.translate_ids(opts)
      [:market, :package_codes].each do |key|
        unless opts[key]
          raise ArgumentError, "Missing #{key} key in options"
        end
      end

      opts[:vertical] ||= "apps"

      path = "#{API_ROOT}/#{opts[:vertical]}/#{opts[:market]}/package-codes2ids"
      params = { package_codes: opts[:package_codes].join(",") }

      AppAnnie.authorized_get(path, params)
    end
  end
end
