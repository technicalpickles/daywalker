module Daywalker
  class TypeConverter # :nodoc:
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

    def self.sym_to_gender_letter(sym)
      case sym
      when :male then 'M'
      when :female then 'F'
      else raise ArgumentError, "Unknown gender #{sym.inspect}"
      end
    end

    def self.blank_to_nil(str)
      str == '' ? nil : str
    end

    def self.normalize_conditions(conditions)
      if conditions[:title].kind_of? Symbol
        conditions[:title] = sym_to_title_abbr(conditions[:title])
      end

      move_value_in_hash(conditions, :district_number, :district)
      move_value_in_hash(conditions, :official_rss_url, :official_rss)

      if conditions[:party].kind_of? Symbol
        conditions[:party] = sym_to_party_letter(conditions[:party])
      end

      move_value_in_hash(conditions, :website_url, :website)
      move_value_in_hash(conditions, :fax_number, :fax)
      move_value_in_hash(conditions, :first_name, :firstname)
      move_value_in_hash(conditions, :middle_name, :middlename)
      move_value_in_hash(conditions, :last_name, :lastname)
      move_value_in_hash(conditions, :webform_url, :webform)

      if conditions[:gender].kind_of? Symbol
        conditions[:gender] = sym_to_gender_letter(conditions[:gender])
      end

      conditions
    end

    protected

    def self.move_value_in_hash(hash, from, to)
      if hash.has_key? from
        hash[to] = hash.delete(from)
      end
    end
  end
end
