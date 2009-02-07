module Daywalker
  class Legislator < Base
    include HappyMapper

    tag 'legislator'
    element 'district_number', Integer, :tag => 'district'
    element 'title', TypeConverter, :parser => :title_abbr_to_sym
    element 'eventful_id', String
    element 'in_office', Boolean
    element 'state', String
    element 'votesmart_id', Integer
    element 'official_rss_url', TypeConverter, :tag => 'official_rss', :parser => :blank_to_nil
    element 'party', TypeConverter, :parser => :party_letter_to_sym
    element 'email', TypeConverter, :parser => :blank_to_nil
    element 'crp_id', String
    element 'website_url', String, :tag => 'website'
    element 'fax_number', String, :tag => 'fax'
    element 'govtrack_id', Integer
    element 'first_name', String, :tag => 'firstname'
    element 'middle_name', String, :tag => 'middlename'
    element 'last_name', String, :tag => 'lastname'
    element 'congress_office', String
    element 'bioguide_id', String
    element 'webform_url', String, :tag => 'webform'
    element 'youtube_url', String
    element 'nickname', TypeConverter, :parser => :blank_to_nil
    element 'phone', String
    element 'fec_id', String
    element 'gender', TypeConverter, :parser => :gender_letter_to_sym
    element 'name_suffix', TypeConverter, :parser => :blank_to_nil
    element 'twitter_id', TypeConverter, :parser => :blank_to_nil
    element 'sunlight_old_id', String
    element 'congresspedia_url', String

    def self.find_all_by_zip(zip)
      raise MissingParameter, 'zip' if zip.nil?
      query = {
        :zip => zip,
        :apikey => Daywalker.api_key
      }
      response = get('/legislators.allForZip.xml', :query => query)

      handle_response(response)
    end

    def self.find(sym, conditions)
      url = case sym
      when :only then '/legislators.get'
      when :all then '/legislators.getList'
      end

      conditions = TypeConverter.convert_conditions(conditions)
      query = conditions.merge(:apikey => Daywalker.api_key)
      response = get(url, :query => query)

      case sym
      when :only then handle_response(response).first
      when :all then handle_response(response)
      end
    end

    def self.method_missing(method, *args, &block)
      if method.to_s =~ /^find_(all_by|by)_([_a-zA-Z]\w*)$/
        conditions = {}
        $2.split('_and_').each_with_index do |key, index|
          conditions[key.to_sym] = args[index]
        end
        find(:all, conditions)
      else
        super
      end
    end

    def self.respond_to?(method)
      if method.to_s =~ /^find_(all_by|by)_([_a-zA-Z]\w*)$/
        true
      else
        super
      end
    end
  end
end
