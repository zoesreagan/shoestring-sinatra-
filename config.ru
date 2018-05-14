require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/TripController'

# models
require './models/UserModel'


# routes
map ('/'){
	run ApplicationController
}

map('/user') {
	run UserController
}

map('/trips') {
	run TripController
}
