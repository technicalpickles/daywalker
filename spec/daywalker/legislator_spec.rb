require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::Legislator do

  before :each do
    FakeWeb.clean_registry
  end

  before :all do
    Daywalker.api_key = 'redacted'
  end

  after :all do
    Daywalker.api_key = nil
  end

  describe 'find_all_by_zip' do

    describe 'happy path' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/legislators.allForZip.xml?zip=27511&apikey=redacted" > legislators_by_zip.xml
        register_uri_with_response 'legislators.allForZip.xml?zip=27511&apikey=redacted', 'legislators_by_zip.xml'

        @legislators = Daywalker::Legislator.find_all_by_zip 27511
      end

      it 'return legislators identified by votersmart ids 119, 21082, 21787, and 10205' do
        @legislators.map{|each| each.votesmart_id}.should == [119, 21082, 21787, 10205]
      end
    end

    describe 'with a bad API key' do
      setup do
        #  curl -i "http://services.sunlightlabs.com/api/legislators.allForZip.xml?zip=27511&apikey=redacted" > legislators_by_zip
        register_uri_with_response 'legislators.allForZip.xml?zip=27511&apikey=redacted', 'legislators_by_zip_bad_api.xml'
      end

      it 'should raise bad API key error' do
        lambda {
          Daywalker::Legislator.find_all_by_zip 27511
        }.should raise_error(Daywalker::BadApiKey) 
      end
    end

    describe 'without a zip code' do
      it 'should raise ArgumentError for missing zip' do
        lambda {
          Daywalker::Legislator.find_all_by_zip nil
        }.should raise_error(ArgumentError, /zip/) 
      end
    end
  end

  describe 'found with find(:one)' do
    describe 'by state and district, with one result,' do
      describe 'happy path' do
        before do
          register_uri_with_response 'legislators.get.xml?apikey=redacted&state=NY&district=4', 'legislators_find_by_ny_district_4.xml'
          @legislator = Daywalker::Legislator.find(:one, :state => 'NY', :district => 4)
        end


        it 'should have votesmart id 119' do
          @legislator.votesmart_id.should == 119
        end
      end

      describe 'by state and district, with bad API key' do
        before do
          register_uri_with_response 'legislators.get.xml?apikey=redacted&state=NY&district=4', 'legislators_find_by_ny_district_4_bad_api.xml'
        end

        it 'should raise a missing parameter error for zip' do
          lambda {
            Daywalker::Legislator.find(:one, :state => 'NY', :district => 4)
          }.should raise_error(Daywalker::BadApiKey) 
        end
      end

      describe 'by state and district, with multiple results' do
        before do
          register_uri_with_response 'legislators.get.xml?state=NY&title=Sen&apikey=redacted', 'legislators_find_one_by_ny_senators.xml'
        end

        it 'should raise an error about multiple legislators returned' do
          lambda {
            Daywalker::Legislator.find(:one, :state => 'NY', :title => :senator)
          }.should raise_error(ArgumentError, "The conditions provided returned multiple results, by only one is expected")
        end
      end
    end
  end

  describe 'found with find(:all)' do
    describe 'by state and title, with multiple results,' do
      describe 'happy path' do
        before do
          # curl -i "http://services.sunlightlabs.com/api/legislators.getList.xml?state=NY&title=Sen&apikey=redacted" > legislators_find_ny_senators.xml
          register_uri_with_response 'legislators.getList.xml?state=NY&apikey=redacted&title=Sen', 'legislators_find_ny_senators.xml'
          @legislators = Daywalker::Legislator.find(:all, :state => 'NY', :title => :senator)
        end

        it 'should return legislators with votesmart ids 55463 and 26976' do
          @legislators.map{|each| each.votesmart_id}.should == [55463, 26976]
        end
      end

      describe 'with bad API key' do
        before do
          register_uri_with_response 'legislators.getList.xml?state=NY&apikey=redacted&title=Sen', 'legislators_find_ny_senators_bad_api.xml'
        end

        it 'should raise BadApiKey error' do
          lambda {
            Daywalker::Legislator.find(:all, :state => 'NY', :title => :senator)
          }.should raise_error(Daywalker::BadApiKey)

        end
      end
    end
  end

  describe 'found with find(:zomg)' do
    it 'should raise ArgumentError' do
      lambda {
        Daywalker::Legislator.find(:zomg, {})
      }.should raise_error(ArgumentError, /zomg/)
    end
  end

  # TODO switch this to mocking
  describe 'dynamic finder find_all_by_state_and_title' do
    before do
      register_uri_with_response 'legislators.getList.xml?state=NY&apikey=redacted&title=Sen', 'legislators_find_ny_senators.xml'

      @legislators = Daywalker::Legislator.find_all_by_state_and_title('NY', :senator)
    end
    
    it 'should return legislators with votesmart ids 55463 and 26976' do
      @legislators.map{|each| each.votesmart_id}.should == [55463, 26976]
    end
    
    it 'should respond to find_all_by_state_and_title' do
      Daywalker::Legislator.should respond_to(:find_all_by_state_and_title)
    end
  end


  describe 'parsed from XML' do
    setup do
      @xml = <<-XML
        <legislator>
          <district>4</district>
          <title>Rep</title>
          <eventful_id>P0-001-000016562-5</eventful_id>
          <in_office>1</in_office>
          <state>NC</state>
          <votesmart_id>119</votesmart_id>
          <official_rss></official_rss>
          <party>D</party>
          <email></email>
          <crp_id>N00002260</crp_id>
          <website>http://price.house.gov/</website>
          <fax>202-225-2014</fax>
          <govtrack_id>400326</govtrack_id>
          <firstname>David</firstname>
          <middlename>Eugene</middlename>
          <lastname>Price</lastname>
          <congress_office>2162 Rayburn House Office Building</congress_office>
          <bioguide_id>P000523</bioguide_id>
          <webform>http://price.house.gov/contact/contact_form.shtml</webform>
          <youtube_url>http://www.youtube.com/repdavidprice</youtube_url>
          <nickname></nickname>
          <phone>202-225-1784</phone>
          <fec_id>H6NC04037</fec_id>
          <gender>M</gender>
          <name_suffix></name_suffix>
          <twitter_id></twitter_id>
          <sunlight_old_id>fakeopenID319</sunlight_old_id>
          <congresspedia_url>http://www.sourcewatch.org/index.php?title=David_Price</congresspedia_url>
        </legislator>
      XML
    end
    subject { Daywalker::Legislator.parse(@xml) }

    specify { subject.district_number.should == 4 }
    specify { subject.title.should == :representative }
    specify { subject.eventful_id.should == 'P0-001-000016562-5' }
    specify { subject.in_office.should be_true }
    specify { subject.state.should == 'NC' }
    specify { subject.votesmart_id.should == 119 }
    specify { subject.official_rss_url.should be_nil } 
    specify { subject.party.should == :democrat }
    specify { subject.email.should be_nil }
    specify { subject.crp_id.should == 'N00002260' }
    specify { subject.website_url.should == 'http://price.house.gov/' }
    specify { subject.fax_number.should == '202-225-2014' }
    specify { subject.govtrack_id.should == 400326 }
    specify { subject.first_name.should == 'David' }
    specify { subject.middle_name.should == 'Eugene' }
    specify { subject.last_name.should == 'Price' }
    specify { subject.congress_office.should == '2162 Rayburn House Office Building' }
    specify { subject.bioguide_id.should == 'P000523' }
    specify { subject.webform_url.should == 'http://price.house.gov/contact/contact_form.shtml' }
    specify { subject.youtube_url.should == 'http://www.youtube.com/repdavidprice' }
    specify { subject.nickname.should be_nil }
    specify { subject.phone.should == '202-225-1784' }
    specify { subject.fec_id.should == 'H6NC04037' }
    specify { subject.gender.should == :male }
    specify { subject.name_suffix.should be_nil }
    specify { subject.twitter_id.should be_nil }
    specify { subject.sunlight_old_id.should == 'fakeopenID319' }
    specify { subject.congresspedia_url.should == 'http://www.sourcewatch.org/index.php?title=David_Price' }
  end

end
