module Daywalker
  class Legislator < Base
    include HappyMapper

    tag 'legislator'
    element 'district', Integer
    element 'title', String
    element 'eventful_id', String
    element 'in_office', Boolean
    element 'state', String
    element 'votesmart_id', Integer
    element 'official_rss', String
    element 'party', String
    element 'email', String
    element 'crp_id', String
    element 'first_name', String, :tag => 'firstname'
    element 'middle_name', String, :tag => 'middlename'
    element 'last_name', String, :tag => 'lastname'
    element 'congress_office', String
    element 'bioguide_id', String
    element 'webform', String
    element 'youtube_url', String
    element 'nickname', String
    element 'phone', String
    element 'fec_id', String
    element 'gender', self, :parser => :gender_letter_to_sym
    element 'name_suffix', String
    element 'twitter_id', String
    element 'sunlight_old_id', String
    element 'congresspedia_url', String

    def self.find_all_by_zip(zip)

      query = {
        :zip => zip,
        :apikey => Daywalker.api_key
      }
      response = get('/legislators.allForZip.xml', :query => query)

      parse(response.body)
    end

    def self.gender_letter_to_sym(letter)
      case letter
      when 'M' then :male
      when 'F' then :female
      else raise "unknown gender #{letter.inspect}"
      end
    end
  end
end
