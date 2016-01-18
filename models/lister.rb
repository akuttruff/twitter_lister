require 'bundler'
require 'sinatra'
require 'json'
require 'twitter'

class Lister

  def initialize(slug, user)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['TOKEN_KEY']
      config.access_token_secret = ENV['TOKEN_SECRET']
    end

    members = client.list_members(user, slug).to_h[:users].map { |h| h[:screen_name] }
    @bios = client.users(members).map { |res| res.to_h[:description] }
  end
  
  def sort_by_frequency
    @frequencies = Hash.new(0)
    @bios.join(" ").split(/\W+/).each { |word| @frequencies[word] += 1 }
    @frequencies = @frequencies.sort_by { |a, b| b }.reverse!
  end

  def write_json
    data = JSON.generate(@frequencies)
    path = File.dirname(__FILE__) + "/../public/json_results.json"
    File.open(path, 'w') do 
      |h| h.puts data
    end		
  end

end
