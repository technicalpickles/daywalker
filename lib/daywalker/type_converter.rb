module Daywalker
  class TypeConverter
    def self.gender_letter_to_sym(letter)
      case letter
      when 'M' then :male
      when 'F' then :female
      else raise ArgumentError, "unknown gender #{letter.inspect}"
      end
    end

    def self.party_letter_to_sym(letter)
      case letter
      when 'D' then :democrat
      when 'R' then :republican
      when 'I' then :independent
      else raise ArgumentError, "unknown party #{letter.inspect}"
      end
    end

    def self.title_abbr_to_sym(abbr)
      case abbr
      when 'Sen' then :senator
      when 'Rep' then :representative
      else raise ArgumentError, "Unknown title #{abbr.inspect}"
      end
    end

    def self.sym_to_title_abbr(sym)
      case sym
      when :senator then 'Sen'
      when :representative then 'Rep'
      else raise ArgumentError, "Unknown title #{sym.inspect}"
      end
    end

    def self.sym_to_party_letter(sym)
      case sym
      when :democrat then 'D'
      when :republican then 'R'
      when :independent then 'I'
      else raise ArgumentError, "Unknown party #{sym.inspect}"
      end
    end

    def self.blank_to_nil(str)
      str == '' ? nil : str
    end

    def self.convert_conditions(conditions)
      if conditions[:title].kind_of? Symbol
        conditions[:title] = sym_to_title_abbr(conditions[:title])
      end

      if conditions.has_key? :district_number
        conditions[:district] = conditions.delete(:district_number)
      end

      if conditions.has_key? :official_rss_url
        conditions[:official_rss] = conditions.delete(:official_rss_url)
      end

      if conditions[:party].kind_of? Symbol
        conditions[:party] = sym_to_party_letter(conditions[:party])
      end

      conditions
    end
  end
end
