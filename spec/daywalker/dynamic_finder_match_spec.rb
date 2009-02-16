require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::DynamicFinderMatch do
  describe 'finding all by valid attributes (state and district number)' do
    subject { Daywalker::DynamicFinderMatch.new(:find_all_by_state_and_district) }

    specify 'should have :all finder' do
      subject.finder.should == :all
    end

    specify 'should have attributes named [:state, :district]' do
      subject.attribute_names.should == [:state, :district]
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
    specify 'should have :one finder' do
      subject.finder.should == :one
    end
  end
end
