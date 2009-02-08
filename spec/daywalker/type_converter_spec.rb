require File.dirname(__FILE__) + '/../spec_helper'

describe Daywalker::TypeConverter do
  describe 'gender_letter_to_sym' do
    it 'should convert F to :female' do
      Daywalker::TypeConverter.gender_letter_to_sym('F').should == :female
    end

    it 'should convert M to :male' do
      Daywalker::TypeConverter.gender_letter_to_sym('M').should == :male
    end

    it 'should raise ArgumentError for unknown genders' do
      lambda {
        Daywalker::TypeConverter.gender_letter_to_sym('aiee')
      }.should raise_error(ArgumentError)
    end
  end

  describe 'party_letter_to_sym' do
    it 'should convert D to :democrat' do
      Daywalker::TypeConverter.party_letter_to_sym('D').should == :democrat
    end

    it 'should convert R to democrat' do
      Daywalker::TypeConverter.party_letter_to_sym('R').should == :republican
    end

    it 'should convert I to independent' do
      Daywalker::TypeConverter.party_letter_to_sym('I').should == :independent
    end

    it 'should raise ArgumentError for unknown parties' do
      lambda {
        Daywalker::TypeConverter.party_letter_to_sym('zomg')
      }.should raise_error(ArgumentError)
    end
  end

  describe 'title_abbr_to_sym' do
    it 'should convert Sen to :senator' do
      Daywalker::TypeConverter.title_abbr_to_sym('Sen').should == :senator
    end

    it 'should convert Rep to :representative' do
      Daywalker::TypeConverter.title_abbr_to_sym('Rep').should == :representative
    end

    it 'should raise ArgumentError for unknown titles' do
      lambda {
        Daywalker::TypeConverter.title_abbr_to_sym('zomg')
      }.should raise_error(ArgumentError)
    end
  end

  describe 'blank_to_nil' do
    it 'should convert "" to nil' do
      Daywalker::TypeConverter.blank_to_nil('').should be_nil
    end

    it 'should leave "zomg" alone' do
      Daywalker::TypeConverter.blank_to_nil('zomg').should == 'zomg'
    end
  end

end
