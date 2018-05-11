require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'


# routes
map ('/'){
	run ApplicationController
}