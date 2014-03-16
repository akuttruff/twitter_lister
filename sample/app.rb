require 'sinatra'


get '/'
	render :index
end

get '/results'
	list = params['list']
	lister = Lister.new(list)
	@word_data = lister.process
	render :results
end