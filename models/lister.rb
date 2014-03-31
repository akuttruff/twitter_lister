
require 'secret.rb'

class Lister

  def initialize(slug_name, user_name)
		@slug_name = slug_name
		@user_name = user_name
	end

	def process

		baseurl 		= "https://api.twitter.com"
		
		slug_path		= "/1.1/lists/show.json"
		query   		= URI.encode_www_form("slug" => @slug_name, "owner_screen_name" => @user_name)
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

		# parses the JSON object to extract the list's numerical ID
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

		# returns array of twitter handles
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

		path = File.dirname(__FILE__) + "/../public/json_results.json"
		File.open(path, 'w') do 
			|h| h.puts json_results
		end		
	end
end
