class ApplicationController < Sinatra::Base
	require 'bundler'
	Bundler.require()

	get '/' do
		"Server is running"
	end

end