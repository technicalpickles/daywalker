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
    element 'firstname', String
    element 'middlename', String
    element 'lastname', String
    element 'congress_office', String
    element 'bioguide_id', String
    element 'webform', String
    element 'youtube_url', String
    element 'nickname', String
    element 'phone', String
    element 'fec_id', String
    element 'gender', String
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
  end
end
