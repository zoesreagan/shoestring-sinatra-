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
	
# get all the trips for the current user
get '/' do
	@trip = Trip.where(user_id: session[:user_id])
	{
		success: true,
		trip: @trip
	}.to_json
end

get '/:id' do
	@trip = Trip.find params[:id]
	@flight = Flight.find @trip[:flight_id]
	@outbound = OutboundFlight.find @flight[:outbound_id]
	@inbound = InboundFlight.find @flight[:inbound_id]

	{
		success: true,
		trip: @trip,
		flight: @flight,
		outbound: @outbound,
		inbound: @inbound
	}.to_json
end



##CREATE TRIP ROUTE
post '/' do
	puts @payload
	puts "this is payload ---------------------"

	@flight = Flight.new
	@flight.origin = @payload[:origin]
	@flight.destination = @payload[:destination]		
	@flight.departs_at = @payload[:departureDate]
	@flight.arrives_at = @payload[:returnDate]
	@flight.num_of_adults = @payload[:numOfPassengers]

	departs_at = @flight.departs_at.to_s.slice(0..9)
	arrives_at = @flight.arrives_at.to_s.slice(0..9)
	num_of_adults = @flight.num_of_adults.to_s

	query_string = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=CsAYiUDotu5fFRg8Gl7WFv4AFCqSxRhQ&origin=' + @flight.origin + '&destination=' + @flight.destination + '&departure_date=' + departs_at + '&return_date=' + arrives_at + '&adults=' + num_of_adults + '&number_of_results=1'

	response = open(query_string).read
	resParsed = JSON.parse(response) 

	@flight.fare = resParsed["results"][0]["fare"]["total_price"]

	@outbound = OutboundFlight.new
	@outbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["flight_number"]
	@outbound.flight_num_2 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][1]["flight_number"]
	@outbound.airline = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["marketing_airline"]

	@outbound.save

	@inbound = InboundFlight.new
	@inbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["flight_number"]
	@inbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][1]["flight_number"]
	@inbound.airline = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["marketing_airline"]

	@inbound.save

	@flight.outbound_id = @outbound[:id]
	@flight.inbound_id = @inbound[:id]


	@flight.save

	# this is how you add something with ActiveRecord.
	@trip = Trip.new #instantiating a new class from Trip model
	@trip.title = @payload[:title]
	@trip.budget = @payload[:budget]
	@trip.saved = @payload[:amountSaved]
	@trip.flight_id = @flight[:id]
	# @trip.hotel_id = @payload[:hotel_id]
	@trip.user_id = session[:user_id]
	@trip.cost = @flight.fare # plus hotel.cost once we get that
	@trip.save





	
	
	# THIS IS IN PROGRESS 
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
