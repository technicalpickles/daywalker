module Daywalker
  # Represents a legislator, either a Senator or Representative.
  #
  # They have the following attributes:
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
  # * phone
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
    def self.find_all_by_zip(zip)
      raise ArgumentError, 'missing required parameter zip' if zip.nil?
      query = {
        :zip => zip,
        :apikey => Daywalker.api_key
      }
      response = get('/legislators.allForZip.xml', :query => query)

      handle_response(response)
    end

    # Find one or many legislators, based on a set of conditions. See 
    # VALID_ATTRIBUTES for possible attributes you can search for.
    # 
    # If you want one legislators, and you expect there is exactly one
    # legislator, use :one. An error will be raised if there are more than
    # one result. An ArgumentErrror will be raised if multiple results come back.
    #
    #   Daywalker::Legislator.find(:one, :state => 'NY', :district => 4)
    #
    # Otherwise, use :all.
    # 
    #   Daywalker::Legislator.find(:all, :state => 'NY', :title => :senator)
    #
    # Additionally, dynamic finders based on these attributes are available:
    #
    #   Daywalker::Legislator.find_by_state_and_district('NY', 4)
    #   Daywalker::Legislator.find_all_by_state_and_senator('NY', :senator)
    def self.find(sym, conditions)
      url = case sym
      when :one then '/legislators.get.xml'
      when :all then '/legislators.getList.xml'
      else raise ArgumentError, "invalid argument #{sym.inspect}, only :one and :all are allowed"
      end

      conditions = TypeConverter.normalize_conditions(conditions)
      query = conditions.merge(:apikey => Daywalker.api_key)
      response = get(url, :query => query)

      case sym
      when :one then handle_response(response).first
      when :all then handle_response(response)
      end
    end

    def self.find_all_by_latitude_and_longitude(latitude, longitude)
      district = District.find_by_latitude_and_longitude(latitude, longitude)

      representative = find_by_state_and_district(district.state, district.number)
      junior_senator = find_by_state_and_district(district.state, :junior_senator)
      senior_senator = find_by_state_and_district(district.state, :senior_senator)

      {
        :representative => representative,
        :junior_senator => junior_senator,
        :senior_senator => senior_senator
      }
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
      else super
      end
    end

    
    def self.create_finder_method(method, finder, attribute_names) # :nodoc:
      class_eval %{
        def self.#{method}(*args)                                             # def self.find_all_by_district_and_state(*args)
          conditions = args.last.kind_of?(Hash) ? args.pop : {}               #   conditions = args.last.kind_of?(Hash) ? args.pop : {}
          [:#{attribute_names.join(', :')}].each_with_index do |key, index|   #   [:district, :state].each_with_index do |key, index|
            conditions[key] = args[index]                                     #     conditions[key] = args[index]
          end                                                                 #   end
          find(#{finder.inspect}, conditions)                                 #   find(:all, conditions)
        end                                                                   # end
      }
    end
  end
end
