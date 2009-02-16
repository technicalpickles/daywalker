module Daywalker
  # Represents a legislator, either a Senator or Representative.
  #
  # They have the following attributes:
  # TODO do this list as a definition list with types and possible values
  # * district (either :junior_seat or :senior_seat (for senators) or the number (for representatives)
  # * title (ether :senator or :representative)
  # * eventful_id (on http://eventful.com)
  # * in_office (true or false)
  # * state (two-letter abbreviation)
  # * votesmart_id (on http://www.votesmart.org)
  # * party (:democrat, :republican, or :independent)
  # * crp_id (on http://opensecrets.org)
  # * website_url
  # * fax_number
  # * govtrack_id (on http://www.govtrack.us)
  # * first_name
  # * middle_name
  # * last_name
  # * congress_office (address in Washington, DC)
  # * bioguide_id (on http://bioguide.congress.gov)
  # * webform_url
  # * youtube_url
  # * nickname
  # * phone # FIXME normalize this to phone_number
  # * fec_id (on http://fec.gov)
  # * gender (:male or :female)
  # * name_suffix
  # * twitter_id (on http://twitter.com)
  # * congresspedia_url
  class Legislator < Base
    include HappyMapper

    tag 'legislator'
    element 'district', TypeConverter, :tag => 'district', :parser => :district_to_sym_or_i
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

    VALID_ATTRIBUTES = [:district, :title, :eventful_id, :in_office, :state, :votesmart_id, :official_rss_url, :party, :email, :crp_id, :website_url, :fax_number, :govtrack_id, :first_name, :middle_name, :last_name, :congress_office, :bioguide_id, :webform_url, :youtube_url, :nickname, :phone, :fec_id, :gender, :name_suffix, :twitter_id, :sunlight_old_id, :congresspedia_url]

    # Find all legislators in a particular zip code
    def self.all_by_zip(zip)
      raise ArgumentError, 'missing required parameter zip' if zip.nil?

      query = {
        :zip => zip,
        :apikey => Daywalker.api_key
      }
      response = get('/legislators.allForZip.xml', :query => query)

      handle_response(response)
    end

    # Find a unique legislator matching a Hash of attribute name/values. See VALID_ATTRIBUTES for possible attributes.
    #
    #   Daywalker::Legislator.unique(:state => 'NY', :district => 4)
    #
    # Dynamic finders based on the attribute names are also possible. This query can be rewritten as:
    #
    #   Daywalker::Legislator.unique_by_state_and_district('NY', :district => 4)
    #
    # Returns a Legislator. ArgumentError is raised if more than one result is found.
    #
    # Gotchas:
    # * Results are case insensative (Richard and richard are equivilant)
    # * Results are exact (Richard vs Rich are not the same)
    def self.unique(conditions)
      conditions = TypeConverter.normalize_conditions(conditions)
      query = conditions.merge(:apikey => Daywalker.api_key)

      response = get('/legislators.get.xml', :query => query)

      handle_response(response).first
    end

    # Find all legislators matching a Hash of attribute name/values. See VALID_ATTRIBUTES for possible attributes.
    #
    #   Daywalker::Legislator.all(:state => 'NY', :title => :senator)
    #
    # Dynamic finders based on the attribute names are also possible. This query can be rewritten as:
    #
    #   Daywalker::Legislator.all_by_state_and_title('NY', :title => :senator)
    #
    # Returns an Array of Legislators.
    #
    # Gotchas:
    # * Results are case insensative (Richard and richard are equivilant)
    # * Results are exact (Richard vs Rich)
    # * nil attributes will match anything, not legislators without a value for the attribute
    def self.all(conditions)
      conditions = TypeConverter.normalize_conditions(conditions)
      query = conditions.merge(:apikey => Daywalker.api_key)

      response = get('/legislators.getList.xml', :query => query)

      handle_response(response)
    end

    # Find all the legislators serving a specific latitude and longitude. This will include the district's Represenative, the Senior Senator, and the Junior Senator.
    #
    # Returns a Hash containing keys :representative, :junior_senator, and :senior_senator, with values corresponding to the appropriate Legislator.
    #
    def self.all_by_latitude_and_longitude(latitude, longitude)
      district = District.unique_by_latitude_and_longitude(latitude, longitude)

      representative = unique_by_state_and_district(district.state, district.number)
      junior_senator = unique_by_state_and_district(district.state, :junior_seat)
      senior_senator = unique_by_state_and_district(district.state, :senior_seat)

      {
        :representative => representative,
        :junior_senator => junior_senator,
        :senior_senator => senior_senator
      }
    end

    # Find all the legislators serving a specific address. This will include the district's Represenative, the Senior Senator, and the Junior Senator.
    #
    # Returns a Hash containing keys :representative, :junior_senator, and :senior_senator, with values corresponding to the appropriate Legislator.
    #
    # Raises Daywalker::AddressError if the address can't be geocoded.
    def self.all_by_address(address)
      location = Daywalker.geocoder.locate(address)

      all_by_latitude_and_longitude(location[:latitude], location[:longitude])
    end

    def self.method_missing(method_id, *args, &block) # :nodoc:
      match = DynamicFinderMatch.new(method_id)
      if match.match?
        create_finder_method(method_id, match.finder, match.attribute_names)
        send(method_id, *args, &block)
      else
        super
      end
    end
    
    def self.respond_to?(method_id, include_private = false) # :nodoc:
      match = DynamicFinderMatch.new(method_id)
      if match.match?
        true
      else
        super
      end
    end

    protected

    def self.handle_bad_request(body) # :nodoc:
      case body
      when "Multiple Legislators Returned" then raise(ArgumentError, "The conditions provided returned multiple results, by only one is expected")
      # FIXME need to catcfh when legislator (or any object, which would mean it goes in super) is not found
      else super
      end
    end

    
    def self.create_finder_method(method, finder, attribute_names) # :nodoc:
      class_eval %{
        def self.#{method}(*args)                                             # def self.all_by_district_and_state(*args)
          conditions = args.last.kind_of?(Hash) ? args.pop : {}               #   conditions = args.last.kind_of?(Hash) ? args.pop : {}
          [:#{attribute_names.join(', :')}].each_with_index do |key, index|   #   [:district, :state].each_with_index do |key, index|
            conditions[key] = args[index]                                     #     conditions[key] = args[index]
          end                                                                 #   end
          #{finder}(conditions)                                               #   all(conditions)
        end                                                                   # end
      }
    end
  end
end
