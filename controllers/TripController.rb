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

	get '/' do

		@trip = Trip.where(user_id: session[:user_id])
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

##NEED ALL HOTELS ROUTE

  get '/hotels' do
    @hotels = Hotel.all
    @hotels.to_json
  end

  get '/hotels/:id' do
    @hotel = Hotel.find params[:id]
    check_in = @hotel.check_in.to_s.slice(0..9)
    check_out = @hotel.check_out.to_s.slice(0..9)
    num_of_rooms = @hotel.num_of_rooms.to_s

    query_string = 'https://api.sandbox.amadeus.com/v1.2/hotels/search-airport?apikey=CsAYiUDotu5fFRg8Gl7WFv4AFCqSxRhQ&location=' + @hotel.location_code + '&check_in=' + @hotel.check_in + '&check_out=' + @hotel.check_out

    pp query_string

    response = open(query_string).read
  end

  post '/hotels' do

    puts @payload, 'this is payload in hotels'

    @hotel = Hotel.new
    @hotel.location = @payload[:location]
    @hotel.check_in = @payload[:checkIn]
    @hotel.check_out = @payload[:checkOut]
    @hotel.save

    {
      success: true,
      message: "Hotel in #{@hotel.location} successfully created",
      added_flight: @hotel
    }.to_json

  end

end
