require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::District do
  # TODO test parsing explicitly, and then don't test each result found in the finders

  describe 'unique_by_latitude_and_longitude' do
    describe 'happy path' do
      before do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=urkeyhere&latitude=40.739157&longitude=-73.990929" > districts_by_latlng.xml
        register_uri_with_response 'districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', 'districts_by_latlng.xml'
      end

      subject { Daywalker::District.unique_by_latitude_and_longitude(40.739157, -73.990929) } 

      specify { subject.state.should == 'NY' }
      specify { subject.number.should == 14 }
    end

    describe 'bad api key' do
      before do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=badkeyhere&latitude=40.739157&longitude=-73.990929" > 'districts_by_latlng_bad_api.xml'
        register_uri_with_response('districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', 'districts_by_latlng_bad_api.xml')
      end

      specify 'should raise Daywalker::BadApiKeyError' do
        lambda {
          Daywalker::District.unique_by_latitude_and_longitude(40.739157, -73.990929)
        }.should raise_error(Daywalker::BadApiKeyError)
      end
    end

    describe 'missing latitude' do
      specify 'should raise ArgumentError for latitude' do
        lambda {
          Daywalker::District.unique_by_latitude_and_longitude(nil, -73.990929)
        }.should raise_error(ArgumentError, /latitude/)
      end
    end

    describe 'missing longitude' do
      specify 'should raise ArgumentError for longitude' do
        lambda {
          Daywalker::District.unique_by_latitude_and_longitude(40.739157, nil)
        }.should raise_error(ArgumentError, /longitude/)
      end
    end
  end

  describe 'all_by_zipcode' do
    describe 'happy path' do
      setup do
        # curl -i "http://services.sunlightlabs.com/api/districts.getDistrictsFromZip.xml?apikey=urkeyhere&zip=27511" > districts_by_zip.xml
        register_uri_with_response('districts.getDistrictsFromZip.xml?apikey=redacted&zip=27511', 'districts_by_zip.xml')
      end

      subject { Daywalker::District.all_by_zipcode(27511) }

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

      specify 'should raise BadApiKeyError' do
        lambda {
          Daywalker::District.all_by_zipcode(27511)
        }.should raise_error(Daywalker::BadApiKeyError)
      end
    end

    describe 'missing zip' do
      specify 'should raise ArgumentError for missing zip' do
        lambda {
          Daywalker::District.all_by_zipcode(nil)
        }.should raise_error(ArgumentError, /zip/)
      end
    end
  end

  describe 'unique_by_address' do
    describe 'happy path' do
      before do
        Daywalker.geocoder.stub!(:locate).with("110 8th St., Troy, NY 12180").and_return({:longitude => -73.684236, :latitude => 42.731245})

        Daywalker::District.stub!(:unique_by_latitude_and_longitude).with(42.731245, -73.684236)
      end

      it 'should use unique_by_latitude_and_longitude' do
        Daywalker::District.should_receive(:unique_by_latitude_and_longitude).with(42.731245, -73.684236)

        Daywalker::District.unique_by_address("110 8th St., Troy, NY 12180")
      end

      it 'should use the geocoder to locate a latitude and longitude' do
        Daywalker.geocoder.should_receive(:locate).with("110 8th St., Troy, NY 12180").and_return({:longitude => -73.684236, :latitude => 42.731245})
        Daywalker::District.unique_by_address("110 8th St., Troy, NY 12180")
      end
    end

    describe 'with nil address' do
      it 'should raise ArgumentError if address is not given' do
        lambda {
          Daywalker::District.unique_by_address(nil)
        }.should raise_error(ArgumentError, /address/)
      end
    end
  end
end

