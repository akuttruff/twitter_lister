require 'sinatra'


get '/' do
  erb :index
end

post '/results' do

	puts params.inspect
	
end

post '/results' do
	slug_name = params['slug_name']
	user_name = params['user_name']

	lister = Lister.new(slug_name, list_name)
	@word_data = lister.process
	
end

