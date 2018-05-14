class TripController < ApplicationController
	# get all of the trips that belong to a user
	# this might be better in the user controller?
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

##CREATE TRIP ROUTE

#UPDATE TRIP ROUTE 
	put '/:id'do
		@trip = Trip.find(params[:id])
		@trip.title = @payload[:title]
		@trip.save
		{
			success: true,
			message: "You updated trip \##{@trip.id}",
			updated_trip: @trip
		}.to_json
	end



	delete '/:id' do
		@trip = Trip.find params[:id]
		@trip.destroy

		{
			success: true,
			message: "trip #{@trip.name} deleted successfully"
		}.to_json
	end

end
