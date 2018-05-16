require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/TripController'

# models
require './models/UserModel'
require './models/TripModel'
require './models/HotelModel'
require './models/FlightModel'
require './models/OutboundFlightModel'
require './models/InboundFlightModel'



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

