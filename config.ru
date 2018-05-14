require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/TripController'


# routes
map ('/'){
	run ApplicationController
}

map('/users') {
	run UserController
}

map ('/trips') {
	run TripController
}