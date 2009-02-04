# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{daywalker}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Nichols"]
  s.date = %q{2009-02-03}
  s.description = %q{TODO}
  s.email = %q{josh@technicalpickles.com}
  s.files = ["VERSION.yml", "lib/daywalker", "lib/daywalker/base.rb", "lib/daywalker/district.rb", "lib/daywalker.rb", "spec/daywalker", "spec/daywalker/district_spec.rb", "spec/daywalker_spec.rb", "spec/fixtures", "spec/fixtures/district_by_latlng.xml", "spec/fixtures/district_by_latlng_bad_api.xml", "spec/fixtures/districts", "spec/fixtures/districts_by_zip.xml", "spec/fixtures/districts_by_zip_bad_api.xml", "spec/spec_helper.rb"]
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
    else
    end
  else
  end
end
