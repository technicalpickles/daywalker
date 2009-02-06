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

  describe 'found by find_all_by_zip' do

    describe 'happy path' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/legislators.allForZip.xml?zip=27511&apikey=8a328abd6ecaa0e335f703c24ef931cc" > legislators_by_zip.xml
        register_uri_with_response 'legislators.allForZip.xml?zip=27511&apikey=redacted', 'legislators_by_zip.xml'

        @legislators = Daywalker::Legislator.find_all_by_zip 27511
      end

      it 'return 4 legislators' do
        @legislators.size.should == 4
      end
      
      it 'should have first legislator with votesmart id 119' do
        @legislators[0].votesmart_id.should == 119
      end

      it 'should have second legislator with votesmart id 21082' do
        @legislators[1].votesmart_id.should == 21082
      end

      it 'should have third legislator with votesmart id 21787' do
        @legislators[2].votesmart_id.should == 21787
      end

      it 'should have fourth legislator with votesmart id 10205' do
        @legislators[3].votesmart_id.should == 10205
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
      it 'should raise a missing parameter error for zip' do
        lambda {
          Daywalker::Legislator.find_all_by_zip nil
        }.should raise_error(Daywalker::MissingParameter, 'zip') 
      end
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
