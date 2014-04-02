require 'sinatra' 
require 'bundler/setup'
require 'oauth'
require './models/lister.rb'

get '/' do
  erb :index
end


# Yes! Keep thinking Skinny Controller, Fat Model (pushing logic into Lister is good)
post '/results' do
	slug_name = params['slug_name']
	user_name = params['user_name']

	lister = Lister.new(slug_name, user_name)
	# rewrite lister.process to return an object w/data required to render the view (dynamic app)
  @results = lister.process 
	erb :results
end
