require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::District do

  before :each do
    FakeWeb.clean_registry
  end

  before :all do
    Daywalker.api_key = 'redacted'
  end

  after :all do
    Daywalker.api_key = nil
  end

  describe 'find_by_latitude_and_longitude' do
    describe 'happy path' do
      before do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=urkeyhere&latitude=40.739157&longitude=-73.990929" > districts_by_latlng.xml
        register_uri_with_response 'districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', 'districts_by_latlng.xml'

      end

      subject { Daywalker::District.find_by_latitude_and_longitude(40.739157, -73.990929) } 

      specify { subject.size == 1 }
      specify { subject.first.state.should == 'NY' }
      specify { subject.first.number.should == 14 }
    end

    describe 'bad api key' do
      before do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=badkeyhere&latitude=40.739157&longitude=-73.990929" > 'districts_by_latlng_bad_api.xml'
        register_uri_with_response('districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', 'districts_by_latlng_bad_api.xml')
      end

      specify 'should raise Daywalker::InvalidApiKey' do
        lambda {
          Daywalker::District.find_by_latitude_and_longitude(40.739157, -73.990929)
        }.should raise_error(Daywalker::BadApiKey)
      end
    end

    describe 'missing latitude' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=urkeyhere&longitude=-73.990929" > 'districts_by_latlng_missing_lat.xml'
        register_uri_with_response('districts.getDistrictFromLatLong.xml?apikey=redacted&longitude=-73.990929', 'districts_by_latlng_missing_lat.xml')
      end

      specify 'should raise ArgumentError for latitude' do
        lambda {
          Daywalker::District.find_by_latitude_and_longitude(nil, -73.990929)
        }.should raise_error(ArgumentError, /latitude/)
      end
    end
  end

  describe 'find_by_zipcode' do
    describe 'happy path' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=urkeyhere&zip=27511" > districts_by_zip.xml
        register_uri_with_response('districts.getDistrictsFromZip.xml?apikey=redacted&zip=27511', 'districts_by_zip.xml')
      end

      subject { Daywalker::District.find_by_zip(27511) }

      specify { subject.size.should == 2 }

      specify { subject[0].state.should == 'NC' }
      specify { subject[0].number.should == 13 }
      
      specify { subject[1].state.should == 'NC' }
      specify { subject[1].number.should == 4 }
    end

    describe 'bad api key' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=badkeyhere&zip=27511" > districts_by_zip_bad_api.xml 
        register_uri_with_response 'districts.getDistrictsFromZip.xml?apikey=redacted&zip=27511', 'districts_by_zip_bad_api.xml'
      end

      specify 'should raise BadApiKey' do
        lambda {
          Daywalker::District.find_by_zip(27511)
        }.should raise_error(Daywalker::BadApiKey)
      end
    end

    describe 'missing zip' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=urkeyhere" > districts_by_zip_missing_zip.xml
        register_uri_with_response 'districts.getDistrictsFromZip.xml?apikey=redacted', 'districts_by_zip_missing_zip.xml'
      end

      specify 'should raise ArgumentError for missing zip' do
        lambda {
          Daywalker::District.find_by_zip(nil)
        }.should raise_error(ArgumentError, /zip/)
      end

    end
  end
end

