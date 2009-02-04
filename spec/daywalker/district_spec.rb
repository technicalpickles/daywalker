require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::District, 'find_by_latlng' do
  before do
    FakeWeb.register_uri('http://services.sunlightlabs.com/api/districts.getDistrictFromLatLong.xml?apikey=redacted&latitude=40.739157&longitude=-73.990929', :response => fixture_path_for('district_by_latlng.xml'))

    Daywalker.api_key = 'redacted'
  end

  subject { Daywalker::District.find_by_latlng(40.739157, -73.990929) } 

  specify { subject.size == 1 }
  specify { subject.first.state.should == 'NY' }
  specify { subject.first.number.should == 14 }
end
