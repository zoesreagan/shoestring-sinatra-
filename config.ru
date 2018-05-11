require 'sinatra/base'
require 'sinatra/activerecord'

# controllers
require './controllers/ApplicationController'
require './controllers/UserController'


# routes
map ('/'){
	run ApplicationController
}

map('/users') {
	run UserController
}
