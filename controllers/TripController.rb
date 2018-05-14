class TripController < ApplicationController
	# get all of the trips that belong to a user
	# this might be better in the user controller? 

	# TEST ROUTE - GET ALL THE TRIPS TO MAKE SURE EVERYTHIGN IS CONNECTED PROPERLY
	get '/' do
		@trips = Trip.all
		{
			success: true,
			message: "You got all the trips",
			trips: @trips
		}.to_json
	end 
	# get '/' do
	# 	# find the user by id
	# 	@trips = Trip.all
	# end

	#check to make sure these line up with database and form before pushing
	# post '/' do
	# 	payload_body = request.body.read
	# 	payload = JSON.parse(payload_body).symbolize_keys

	# 	@trip = Trip.new
	# 	@trip.name = payload[:name]
	# 	@trip.budget = payload[:budget]



	# 	@trip.save
	# end

	delete '/:id' do
		@trip = Trip.find params[:id]
		@trip.destroy

		{
			success: true,
			message: "trip #{@trip.name} deleted successfully"
		}.to_json
	end

end