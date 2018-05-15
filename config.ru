require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/TripController'
require './controllers/FlightController'

# models
require './models/UserModel'
require './models/TripModel'
require './models/HotelModel'
require './models/FlightModel'



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

map('/flights') {
	run FlightController
}
