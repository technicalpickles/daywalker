require 'happymapper'
require 'httparty'
require 'graticule'

require 'daywalker/base'
require 'daywalker/type_converter'
require 'daywalker/dynamic_finder_match'
require 'daywalker/district'
require 'daywalker/legislator'
require 'daywalker/geocoder'

module Daywalker
  # Set the API to be used
  def self.api_key=(api_key)
    @api_key = api_key
  end

  # Get the API to be used
  def self.api_key
    @api_key
  end

  def self.geocoder=(geocoder)
    @geocoder = geocoder
  end

  def self.geocoder
    @geocoder
  end

  self.geocoder = Daywalker::Geocoder.new

  # Error for when you use the API with a bad API key
  class BadApiKey < StandardError
  end

  # Error for when an address can't be geocoded
  class AddressError < StandardError
  end

  # Error for when an object was specifically looked for, but does not exist
  class NotFoundError < StandardError
  end
end
