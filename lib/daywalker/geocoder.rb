module Daywalker
  class Geocoder
    def locate(address)
      location = geocoder.locate(address)
      { :longitude => location.longitude, :latitude => location.latitude }
    end

    private

    def geocoder
      Graticule.service(:geocoder_us).new
    end

  end
end
