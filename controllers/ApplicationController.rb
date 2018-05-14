class ApplicationController < Sinatra::Base
	require 'bundler'
	Bundler.require()
  
  register Sinatra::CrossOrigin
  
  ActiveRecord::Base.establish_connection(
	    :adapter => 'postgresql', 
	    :database => 'shoestring'
	)
  
  use Rack::Session::Cookie,  :key => 'rack.session',
                              :path => '/',
                              :secret => 'secret'

	get '/' do
		{
      success: false,
      message: "Please consult the API documentation"
    }.to_json
	end

	not_found do
    halt 404
  end

  configure do
    enable :cross_origin
  end #cross-origin
  set :allow_origin, :any
  set :allow_methods, [:get, :post,:delete, :put, :options]

  options '*' do
    p "opi"
    response.headers['Allow'] = 'HEAD, GET, POST, PUT, PATCH, DELETE'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  end
end
