module Daywalker
  # :nodoc:
  class DynamicFinderMatch
    attr_accessor :finder, :attribute_names
    def initialize(method)
      case method.to_s
       when /^find_(all_by|by)_([_a-zA-Z]\w*)$/
         @finder = case $1
                   when 'all_by' then :all
                   when 'by' then :one
                   end
         @attribute_names = $2.split('_and_').map {|each| each.to_sym}
      end
    end

    def match?
      @attribute_names && @attribute_names.all? do |each|
        Daywalker::Legislator::VALID_ATTRIBUTES.include? each
      end
    end

  end
end
