require 'happymapper'
require 'httparty'

require 'daywalker/base'
require 'daywalker/type_converter'
require 'daywalker/dynamic_finder_match'
require 'daywalker/district'
require 'daywalker/legislator'

module Daywalker
  def self.api_key=(api_key)
    @api_key = api_key
  end
  def self.api_key
    @api_key
  end

  class BadApiKey < StandardError
  end

  class MissingParameter < StandardError
  end
end
