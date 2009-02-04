module Daywalker
  class District < Base
    class MissingZip < StandardError; end

    include HappyMapper

    tag     'district'
    element 'number', Integer
    element 'state', String

    def self.find_by_latlng(lat, lng)
      query = { :latitude => lat, :longitude => lng, :apikey => Daywalker.api_key }
      response = get('/districts.getDistrictFromLatLong.xml', :query => query)
      handle_response(response)
    end

    def self.find_by_zip(zip)
      query = { :zip => zip, :apikey => Daywalker.api_key }
      response = get('/districts.getDistrictsFromZip.xml', :query => query)

      handle_response(response)
    end

    protected

    def self.handle_response(response)
      case response.code.to_i
      when 403 then raise BadApiKey
      when 200 then parse(response.body)

      when 400 then handle_error(response.body)
      else          raise "Don't know how to handle code #{response.code.inspect}"
      end
    end

    def self.handle_error(body)
      case body
      when "Missing Parameter: 'zip'"
        raise MissingZip
      else
        raise "Don't know how to handle #{body.inspect}"
      end

    end
  end
end
