module Daywalker
  class Base
    include HTTParty
    base_uri 'http://services.sunlightlabs.com/api'

    protected

    def self.handle_response(response)
      case response.code.to_i
      when 403 then raise BadApiKey
      when 200 then parse(response.body)

      when 400 then handle_bad_request(response.body)
      else          raise "Don't know how to handle code #{response.code.inspect}"
      end
    end

    def self.handle_bad_request(body)
      raise "Don't know how to handle #{body.inspect}"
    end
  end
end
