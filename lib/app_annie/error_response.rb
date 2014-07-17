module AppAnnie
  class ErrorResponse
    def self.raise_for(response)
      case response.status
      when 401 then raise Unauthorized, "Invalid API key - set an env var for APPANNIE_API_KEY or set AppAnnie.api_key manually"
      when 429 then raise RateLimitExceeded
      when 500 then raise ServerError
      when 503 then raise ServerUnavailable
      else raise BadResponse, "An error occurred. Response code: #{response.status} message: #{response.body}"
      end
    end
  end
end
