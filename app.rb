require 'json'
require 'net/http'
require 'uri'
require 'oauth'
require './secret.rb'

# use TWITTER_HANDLES stored in secret.rb for screen_name param
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
data = JSON.parse(response.body)

# 'description' will give us bios
# JSON array -> string -> split strings of words
bio = data.map { |h| h["description"] }
bio_string = bio.join
bio_string.downcase!
words = bio_string.split(" ")

# create hash to store word frequencies 
frequencies = Hash.new(0)
words.each { |word| frequencies[word] += 1 }
frequencies = frequencies.sort_by {|a, b| b }
frequencies.reverse!

# -> and back to JSON to save as JavaScript object
zen_masters = JSON.generate(frequencies)
puts zen_masters
  	
# use d3 to illustrate findings
