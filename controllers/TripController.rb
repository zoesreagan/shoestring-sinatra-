class TripController < ApplicationController
	## REMEMBER TO PUT IN FILTER SO THAT TRIPS CANNOT BE VIEWED WITHOUT LOGGING IN
	# filter to allow JSON requests to be processed
  before do
    payload_body = request.body.read
    if(payload_body != "")
    @payload = JSON.parse(payload_body).symbolize_keys
    #parsing the payload body as JSON and converting keys to hashes


    puts "-----------------------------------------------HERE IS OUR PAYLOAD"
    p @payload
    puts "-----------------------------------------------------------------"
  end
end

	# TEST ROUTE - GET ALL THE TRIPS TO MAKE SURE EVERYTHIGN IS CONNECTED PROPERLY
	# get '/' do
	# 	@trips = Trip.all
	# 	{
	# 		success: true,
	# 		message: "You got all the trips",
	# 		trips: @trips
	# 	}.to_json
	# end 
	# get all of the trips that belong to a user- HANNAH

	# TEST ROUTE - GET ALL THE TRIPS TO MAKE SURE EVERYTHING IS CONNECTED PROPERLY

	get '/' do
		@user = User.find session[:user_id]
		@trip = Trip.find_by user_id: session[:user_id]

		{
			success: true,
			message: "Here is a list of trips for #{@user.name}",
			trip: @trip
		}.to_json

		
		# this_users_trips = user.trips
	# 	# find the user by id
	# 	@trips = Trip.all
	end


	#check to make sure these line up with database and form before pushing
	# post '/' do
	# 	payload_body = request.body.read
	# 	payload = JSON.parse(payload_body).symbolize_keys

	# 	@trip = Trip.new
	# 	@trip.name = payload[:name]
	# 	@trip.budget = payload[:budget]



	# 	@trip.save
	# end

##CREATE TRIP ROUTE

#UPDATE TRIP ROUTE 
	put '/:id'do
		@trip = Trip.find(params[:id])
		@trip.title = @payload[:title]
		@trip.budget = @payload[:budget]
		@trip.saved = @payload[:saved]
		@trip.flight_id = @payload[:@flight_id]
		@trip.hotel_id = @payload[:hotel_id]
		@trip.save
		{
			success: true,
			message: "You updated trip \##{@trip.id}",
			updated_trip: @trip
		}.to_json
	end

#DELETE TRIP ROUTE
	delete '/:id' do
		@trip = Trip.find params[:id]
		@trip.destroy

		{
			success: true,
			message: "trip #{@trip.title} deleted successfully"
		}.to_json
	end

end
