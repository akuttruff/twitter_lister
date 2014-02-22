require 'json'
require 'net/http'
require 'uri'
require 'oauth'
require './secret.rb'

# the GET users/lookup resource takes the screen_name paramater
# use TWITTER_HANDLES stored in secret.rb 
# curl https://twitter.com/mjfreshyfresh/zen-masters/members > handles.html 
# use regex to extract twitter screennames 
# (couldn't get regex to work, created array by hand - d'oh!)

baseurl = "https://api.twitter.com"
path    = "/1.1/users/lookup.json"
query   = URI.encode_www_form("screen_name" => TWITTER_HANDLES)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new(address.request_uri)

# sets up HTTP

http             = Net::HTTP.new(address.host, address.port)
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# CONSUMER_KEY and ACCESS_TOKEN stored in secret.rb

request.oauth!(http, CONSUMER_KEY, ACCESS_TOKEN)
http.start
response = http.request(request)

# creates a JSON representation of the members' info;
# 'description' will give us bios

if response.code == '200' then
  data = JSON.parse(response.body)
end
 
data.each do |handle|
	description = handle["description"]
	puts description
end
  	 
 
  
#  words = $description.split(" ")
#  sorted_words = words.sort
#  puts sorted_words
#  end

# take JSON array and split into separate string values


# write out data to a static .js file (??)
# use d3 to illustrate findings
