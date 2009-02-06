module Daywalker
  class Legislator < Base
    include HappyMapper

    tag 'legislator'
    element 'district_number', Integer, :tag => 'district'
    element 'title', self, :parser => :title_abbr_to_sym
    element 'eventful_id', String
    element 'in_office', Boolean
    element 'state', String
    element 'votesmart_id', Integer
    element 'official_rss_url', self, :tag => 'official_rss', :parser => :blank_to_nil
    element 'party', self, :parser => :party_letter_to_sym
    element 'email', self, :parser => :blank_to_nil
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
    element 'nickname', self, :parser => :blank_to_nil
    element 'phone', String
    element 'fec_id', String
    element 'gender', self, :parser => :gender_letter_to_sym
    element 'name_suffix', self, :parser => :blank_to_nil
    element 'twitter_id', self, :parser => :blank_to_nil
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

    def self.find(conditions)
      query = conditions.merge(:apikey => Daywalker.api_key)
      response = get('/legislators.getList', :query => query)
      parse(response.body)
    end

    protected

    def self.gender_letter_to_sym(letter)
      case letter
      when 'M' then :male
      when 'F' then :female
      else raise "unknown gender #{letter.inspect}"
      end
    end

    def self.party_letter_to_sym(letter)
      case letter
      when 'D' then :democrat
      when 'R' then :republican
      when 'I' then :independent
      else raise "Unknown party #{letter.inspect}"
      end
    end

    def self.title_abbr_to_sym(abbr)
      case abbr
      when 'Sen' then :senator
      when 'Rep' then :representative
      else raise "Unknown title #{abbr.inspect}"
      end
    end

    def self.blank_to_nil(str)
      str == '' ? nil : str
    end
  end
end
