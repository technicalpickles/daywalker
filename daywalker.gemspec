# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{daywalker}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2009-03-30}
  s.description = %q{TODO}
  s.email = %q{josh@technicalpickles.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/daywalker", "lib/daywalker/base.rb", "lib/daywalker/district.rb", "lib/daywalker/dynamic_finder_match.rb", "lib/daywalker/geocoder.rb", "lib/daywalker/legislator.rb", "lib/daywalker/type_converter.rb", "lib/daywalker.rb", "spec/daywalker", "spec/daywalker/district_spec.rb", "spec/daywalker/dynamic_finder_match_spec.rb", "spec/daywalker/geocoder_spec.rb", "spec/daywalker/legislator_spec.rb", "spec/daywalker/type_converter_spec.rb", "spec/daywalker_spec.rb", "spec/fixtures", "spec/fixtures/districts_by_latlng.xml", "spec/fixtures/districts_by_latlng_bad_api.xml", "spec/fixtures/districts_by_latlng_missing_lat.xml", "spec/fixtures/districts_by_zip.xml", "spec/fixtures/districts_by_zip_bad_api.xml", "spec/fixtures/districts_by_zip_missing_zip.xml", "spec/fixtures/get_nonexistent_legislator.xml", "spec/fixtures/legislators_all.xml", "spec/fixtures/legislators_by_zip.xml", "spec/fixtures/legislators_by_zip_bad_api.xml", "spec/fixtures/legislators_find_by_ny_district_4.xml", "spec/fixtures/legislators_find_by_ny_district_4_bad_api.xml", "spec/fixtures/legislators_find_ny_senators.xml", "spec/fixtures/legislators_find_ny_senators_bad_api.xml", "spec/fixtures/legislators_find_one_by_ny_senators.xml", "spec/fixtures/rpi_location.yml", "spec/spec_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/technicalpickles/daywalker}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<happymapper>, [">= 0.2.2"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.3.0"])
      s.add_runtime_dependency(%q<graticule>, [">= 0.2.8"])
    else
      s.add_dependency(%q<happymapper>, [">= 0.2.2"])
      s.add_dependency(%q<httparty>, [">= 0.3.0"])
      s.add_dependency(%q<graticule>, [">= 0.2.8"])
    end
  else
    s.add_dependency(%q<happymapper>, [">= 0.2.2"])
    s.add_dependency(%q<httparty>, [">= 0.3.0"])
    s.add_dependency(%q<graticule>, [">= 0.2.8"])
  end
end
