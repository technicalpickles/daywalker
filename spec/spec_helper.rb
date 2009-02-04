require 'rubygems'
require 'spec'
require 'fake_web'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__), '..', 'lib')

require 'daywalker'

FakeWeb.allow_net_connect = false

Spec::Runner.configure do |config|
  
end

def fixture_path_for(fixture)
  File.join File.dirname(__FILE__), 'fixtures', fixture
end
