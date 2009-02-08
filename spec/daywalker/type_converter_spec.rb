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

  describe 'sym_to_title_abbr' do
    it 'should convert :senator to Sen' do
      Daywalker::TypeConverter.sym_to_title_abbr(:senator).should == 'Sen'
    end

    it 'should convert :representative to Rep' do
      Daywalker::TypeConverter.sym_to_title_abbr(:representative).should == 'Rep'
    end

    it 'should raise ArgumentError for unknown titles' do
      lambda {
        Daywalker::TypeConverter.sym_to_title_abbr(:zomg)
      }.should raise_error(ArgumentError)
    end
  end

  describe 'sym_to_party_letter' do
    it 'should convert :democrat to D' do
      Daywalker::TypeConverter.sym_to_party_letter(:democrat).should == 'D'
    end

    it 'should convert :republican to R' do
      Daywalker::TypeConverter.sym_to_party_letter(:republican).should == 'R'
    end

    it 'should convert :independent to I' do
      Daywalker::TypeConverter.sym_to_party_letter(:independent).should == 'I'
    end

    it 'should raise ArgumentError for unknown parties' do
      lambda {
        Daywalker::TypeConverter.sym_to_party_letter(:zomg)
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

  describe 'convert_conditions' do
    before do
      @conditions = {:title => :senator, :district_number => 5, :official_rss_url => 'http://zomg.com/index.rss', :party => :democrat}
    end

    it 'should convert title value' do
      Daywalker::TypeConverter.should_receive(:sym_to_title_abbr).with(:senator)
      Daywalker::TypeConverter.convert_conditions(@conditions)
    end

    it 'should copy district_number value to district' do
      Daywalker::TypeConverter.convert_conditions(@conditions)[:district].should == 5
    end

    it 'should remove district_number value' do
      Daywalker::TypeConverter.convert_conditions(@conditions).should_not have_key(:district_number)
    end

    it 'should copy official_rss_url value to official_rss' do
      Daywalker::TypeConverter.convert_conditions(@conditions)[:official_rss].should == 'http://zomg.com/index.rss'
    end

    it 'should remove official_rss_url value' do
      Daywalker::TypeConverter.convert_conditions(@conditions).should_not have_key(:official_rss_url)
    end

    it 'should convert party value' do
      Daywalker::TypeConverter.should_receive(:sym_to_party_letter).with(:democrat)
      Daywalker::TypeConverter.convert_conditions(@conditions)
    end

  end

end
