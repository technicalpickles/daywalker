module Daywalker
  class District < Base
    include HappyMapper

    tag     'district'
    element 'number', Integer
    element 'state', String

    def self.find_by_latlng(lat, lng)
      # TODO use ArgumentError
      raise(MissingParameter, 'latitude') if lat.nil?

      query = {
        :latitude => lat,
        :longitude => lng,
        :apikey => Daywalker.api_key
      }
      response = get('/districts.getDistrictFromLatLong.xml', :query => query)
      handle_response(response)
    end

    def self.find_by_zip(zip)
      raise(MissingParameter, 'zip') if zip.nil?

      query = {
        :zip => zip,
        :apikey => Daywalker.api_key
      }
      response = get('/districts.getDistrictsFromZip.xml', :query => query)

      handle_response(response)
    end

  end
end
