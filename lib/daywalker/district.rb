module Daywalker
  class District < Base
    include HappyMapper
    tag     'district'
    element 'number', Integer
    element 'state', String

    def self.find_by_latlng(lat, lng)
      query = { :latitude => lat, :longitude => lng, :apikey => Daywalker.api_key }
      response = get('/districts.getDistrictFromLatLong.xml', :query => query)

      case response.code.to_i
      when 403
        raise BadApiKey
      when 200
        parse(response.body)
      else
        raise "Don't know how to handle code #{response.code.inspect}"
      end
    end

  end
end
