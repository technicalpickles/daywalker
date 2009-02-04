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
        # curl -i "http://services.sunlightlabs.com/api/legislators.allForZip.xml?zip=27511&apikey=8a328abd6ecaa0e335f703c24ef931cc" > legislators_by_zip.xml
        register_uri_with_response 'legislators.allForZip.xml?zip=27511&apikey=redacted', 'legislators_by_zip.xml'
      end

      subject { Daywalker::Legislator.find_all_by_zip 27511 }

      specify { subject.size.should == 4 }
    end

  end

  describe '.parse' do
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

    specify { subject.district.should == 4 }
    specify { subject.title.should == 'Rep' }
    specify { subject.eventful_id.should == 'P0-001-000016562-5' }
    specify { subject.in_office.should be_true }
    specify { subject.state.should == 'NC' }
    specify { subject.votesmart_id.should == 119 }
    specify { subject.official_rss.should == '' } 
    specify { subject.party.should == 'D' }
    specify { subject.email.should == '' }
    specify { subject.crp_id.should == 'N00002260' }
    specify { subject.firstname.should == 'David' }
    specify { subject.middlename.should == 'Eugene' }
    specify { subject.lastname.should == 'Price' }
    specify { subject.congress_office.should == '2162 Rayburn House Office Building' }
    specify { subject.bioguide_id.should == 'P000523' }
    specify { subject.webform.should == 'http://price.house.gov/contact/contact_form.shtml' }
    specify { subject.youtube_url.should == 'http://www.youtube.com/repdavidprice' }
    specify { subject.nickname.should == '' }
    specify { subject.phone.should == '202-225-1784' }
    specify { subject.fec_id.should == 'H6NC04037' }
    specify { subject.gender.should == 'M' }
    specify { subject.name_suffix.should == '' }
    specify { subject.twitter_id.should == '' }
    specify { subject.sunlight_old_id.should == 'fakeopenID319' }
    specify { subject.congresspedia_url.should == 'http://www.sourcewatch.org/index.php?title=David_Price' }
  end

end
