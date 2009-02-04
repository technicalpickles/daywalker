require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::District do

  before :all do
    Daywalker.api_key = 'redacted'
  end

  after :all do
    Daywalker.api_key = nil
  end

  describe 'find_by_latlng' do
    describe 'happy path' do
      before do
        FakeWeb.register_uri('http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', :response => fixture_path_for('district_by_latlng.xml'))

      end

      subject { Daywalker::District.find_by_latlng(40.739157, -73.990929) } 

      specify { subject.size == 1 }
      specify { subject.first.state.should == 'NY' }
      specify { subject.first.number.should == 14 }
    end

    describe 'bad api key' do
      before do
        FakeWeb.register_uri('http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', :response => fixture_path_for('district_by_latlng_bad_api.xml'))
      end

      specify 'should raise Daywalker::InvalidApiKey' do
        lambda {
          Daywalker::District.find_by_latlng(40.739157, -73.990929)
        }.should raise_error(Daywalker::BadApiKey)
      end

    end
  end

  describe 'find_by_zipcode' do
    describe 'happy path' do
      setup do
        FakeWeb.register_uri('http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=redacted&zip=27511', :response => fixture_path_for('districts_by_zip.xml'))
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
        FakeWeb.register_uri('http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=redacted&zip=27511', :response => fixture_path_for('districts_by_zip_bad_api.xml'))
      end

      specify 'should raise BadApiKey' do
        lambda {
          Daywalker::District.find_by_zip(27511)
        }.should raise_error(Daywalker::BadApiKey)
      end

    end
  end
end

