require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::DynamicFinderMatch do
  describe 'finding all by valid attributes (state and district number)' do
    subject { Daywalker::DynamicFinderMatch.new(:find_all_by_state_and_district_number) }

    specify 'should have :all finder' do
      subject.finder.should == :all
    end

    specify 'should have attributes named [:state, :district_number]' do
      subject.attribute_names.should == [:state, :district_number]
    end

    specify { should be_a_match }
  end

  describe 'finding all by invalid attributes (foo and bar)' do
    subject { Daywalker::DynamicFinderMatch.new(:find_all_by_foo_and_bar) }
    specify { should_not be_a_match }
  end

  describe 'finding one by valid attrribute (govtrack_id)' do
    subject { Daywalker::DynamicFinderMatch.new(:find_by_govtrack_id) }
    specify { should be_a_match }
    specify 'should have :govtrack_id attribute' do
      subject.attribute_names.should == [:govtrack_id]
    end
    specify 'should have :only finder' do
      subject.finder.should == :only
    end
  end
end
