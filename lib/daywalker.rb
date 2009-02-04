require 'happymapper'
require 'httparty'

require 'daywalker/base'
require 'daywalker/district'

module Daywalker
  def self.api_key=(api_key)
    @api_key = api_key
  end
  def self.api_key
    @api_key
  end
end
