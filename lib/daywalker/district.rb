module Daywalker
  # Represents a Congressional district.
  #
  # They have the following attributes:
  # * number
  # * state (as a two-letter abbreviation)
  class District < Base
    include HappyMapper

    tag     'district'
    element 'number', Integer
    element 'state', String

    # Find districts by latitude and longitude.
    def self.find_by_latlng(lat, lng)
      # TODO use ArgumentError
      raise(MissingParameter, 'latitude') if lat.nil?

      query = {
        :latitude => lat,
        :longitude => lng,
        :apikey => Daywalker.api_key
      }
      response = get('/districts.getDistrictFromLatLong.xml', :query => query)
      handle_response(response) # TODO should only ever return one?
    end

    # Find districts by zip code
    def self.find_by_zip(zip)
      # TODO use ArgumentError
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
