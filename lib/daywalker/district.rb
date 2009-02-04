module Daywalker
  class District < Base
    include HappyMapper
    tag     'district'
    element 'number', Integer
    element 'state', String

    def self.find_by_latlng(lat, lng)
      query = { :latitude => lat, :longitude => lng, :apikey => Daywalker.api_key }
      response = get('/districts.getDistrictFromLatLong.xml', :query => query)

      parse(response.body)
    end

  end
end
