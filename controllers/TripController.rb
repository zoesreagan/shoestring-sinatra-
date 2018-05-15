class TripController < ApplicationController
	## REMEMBER TO PUT IN FILTER SO THAT TRIPS CANNOT BE VIEWED WITHOUT LOGGING IN
	# filter to allow JSON requests to be processed
  before do
    payload_body = request.body.read
    if(payload_body != "")
    @payload = JSON.parse(payload_body).symbolize_keys
    #parsing the payload body as JSON and converting keys to hashes
	end

  	if !session[:logged_in]
	      halt 200, {
	        success: false,
	        message: 'you are not loged in'
	      }.to_json
	end
end
	before do
	    
	end
	# get all of the trips that belong to a user- HANNAH

	get '/' do

		#@user = User.find session[:user_id]
		# @trip = Trip.find_by user_id: session[:user_id] <-- ADD BACK IN ONCE LOGIN FUNCTION IS ADDED
		# @user = User.find 1
		@trip = Trip.where(user_id: session[:user_id])
		# @trip = Trip.where(user_id: 1).find_each  # hardcoding this for react development, needs to be removed
		{
			success: true,
			# message: "Here is a list of trips for #{@user.name}",
			trip: @trip
		}.to_json

	end

##CREATE TRIP ROUTE
post '/' do
	puts @payload
	puts "this is payload ---------------------"

	# this is how you add something with ActiveRecord.
	@trip = Trip.new #instantiating a new class from Trip model
	@trip.title = @payload[:title]
	@trip.budget = @payload[:budget]
	@trip.saved = @payload[:amountSaved]
	@trip.flight_id = @payload[:flight_id]
	@trip.hotel_id = @payload[:hotel_id]
	@trip.user_id = session[:user_id]
	@trip.save

	{
		success: true,
		message: "Trip #{@trip.title} successfully created",
		added_trip: @trip,
	}.to_json

end


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
