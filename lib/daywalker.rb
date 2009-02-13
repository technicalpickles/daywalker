require 'happymapper'
require 'httparty'

require 'daywalker/base'
require 'daywalker/type_converter'
require 'daywalker/dynamic_finder_match'
require 'daywalker/district'
require 'daywalker/legislator'

module Daywalker
  # Set the API to be used
  def self.api_key=(api_key)
    @api_key = api_key
  end

  # Get the API to be used
  def self.api_key
    @api_key
  end

  # Error for when you use the API with a bad API key
  class BadApiKey < StandardError
  end
end
