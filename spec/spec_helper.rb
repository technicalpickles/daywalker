require 'rubygems'
require 'spec'
require 'fake_web'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__), '..', 'lib')

require 'daywalker'

FakeWeb.allow_net_connect = false

Spec::Runner.configure do |config|
  config.before :each do
    FakeWeb.clean_registry
  end

  config.before :all do
    Daywalker.api_key = 'redacted'
  end

  config.after :all do
    Daywalker.api_key = nil
  end

end

def fixture_path_for(response)
  File.join File.dirname(__FILE__), 'fixtures', response
end

def register_uri_with_response(uri, response)
  FakeWeb.register_uri("http://services.sunlightlabs.com/api/#{uri}", :response => fixture_path_for(response))
end
