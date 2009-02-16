require 'rubygems'
require 'daywalker'

Daywalker.api_key = '8a328abd6ecaa0e335f703c24ef931cc'

legislators = 

legislators_with_twitter = Daywalker::Legislator.all.select do |legislator|
  ! legislator.twitter_id.nil?
end

legislators_with_twitter.each do |legislator|
  puts "#{legislator.full_name}: http://twitter.com/#{legislator.twitter_id}"
end
