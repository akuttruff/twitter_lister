require 'sinatra' 
require 'bundler/setup'
require 'oauth'
require './models/lister.rb'

get '/' do
  erb :index
end

post '/results' do

  slug = params['slug']
  user = params['user']

  lister = Lister.new(slug, user)
  lister.sort_by_frequency
  lister.write_json

  erb :results

end
