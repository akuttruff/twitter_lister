require 'json'
require 'net/http'
require 'uri'
require 'oauth'
require './secret.rb'

		baseurl 		= "https://api.twitter.com"
		
		slug_path		= "/1.1/lists/show.json"
		query   		= URI.encode_www_form("slug" => "zen-masters", "owner_screen_name" => "mjfreshyfresh")
		address 		= URI("#{baseurl}#{slug_path}?#{query}")
		request 		= Net::HTTP::Get.new(address.request_uri)

		# Set up HTTP
		http             = Net::HTTP.new(address.host, address.port)
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# CONSUMER_KEY and ACCESS_TOKEN stored in secret.rb
		request.oauth!(http, CONSUMER_KEY, ACCESS_TOKEN)
		http.start
		response = http.request(request)

		# Create a JSON representation of the members' info
		slugData = JSON.parse(response.body)
		id = slugData["id"]

		list_path		= "/1.1/lists/members.json"
		query   		= URI.encode_www_form("list_id" => id)
		address 		= URI("#{baseurl}#{list_path}?#{query}")
		request 		= Net::HTTP::Get.new(address.request_uri)

		# Set up HTTP
		http             = Net::HTTP.new(address.host, address.port)
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# CONSUMER_KEY and ACCESS_TOKEN stored in secret.rb
		request.oauth!(http, CONSUMER_KEY, ACCESS_TOKEN)
		http.start
		response = http.request(request)

		# Create a JSON representation of the members' info
		data = JSON.parse(response.body)
		list_data = data["users"].map { |h| h["screen_name"] }
		
		# use cursors to iterate over next 20 users until all handles are displayed

		bio_path    = "/1.1/users/lookup.json"
		query   		= URI.encode_www_form("screen_name" => list_data)
		address 		= URI("#{baseurl}#{bio_path}?#{query}")
		request 		= Net::HTTP::Get.new(address.request_uri)


		# Set up HTTP
		http             = Net::HTTP.new(address.host, address.port)
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# CONSUMER_KEY and ACCESS_TOKEN stored in secret.rb
		request.oauth!(http, CONSUMER_KEY, ACCESS_TOKEN)
		http.start
		response = http.request(request)

		# Create a JSON representation of the members' info
		data = JSON.parse(response.body)

		# Convert JSON array to string and split into separate words
		bio = data.map { |h| h["description"].downcase }
		bio_string = bio.join(" ")
		words = bio_string.split(/\W+/)

		# Create hash to sort word frequencies 
		frequencies = Hash.new(0)
		words.each { |word| frequencies[word] += 1 }
		frequencies = frequencies.sort_by {|a, b| b }
		frequencies.reverse!

		# Convert data back to JSON to save as JavaScript object
		json_results = JSON.generate(frequencies)
		File.open('json_results.json','w') do 
			|h| h.puts json_results
		end
		





			