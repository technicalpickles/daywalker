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
  # Set the API to be used. This must be set when using Daywalker, BadApiKeyErrors will be occur.
  def self.api_key=(api_key)
    @api_key = api_key
  end

  # Get the API to be used
  def self.api_key
    @api_key
  end

  def self.geocoder=(geocoder) # :nodoc:
    @geocoder = geocoder
  end

  def self.geocoder # :nodoc:
    @geocoder
  end

  self.geocoder = Daywalker::Geocoder.new

  # Error for when you use the API with a bad API key
  class BadApiKeyError < StandardError
  end

  # Error for when an address can't be geocoded
  class AddressError < StandardError
  end

  # Error for when an object was specifically looked for, but does not exist
  class NotFoundError < StandardError
  end
end
