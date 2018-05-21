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
  @hotel = Hotel.find @trip[:hotel_id]

	{
		success: true,
		trip: @trip,
		flight: @flight,
		outbound: @outbound,
		inbound: @inbound,
    	hotel: @hotel
	}.to_json
end



##CREATE TRIP ROUTE
post '/' do
	puts @payload
	puts "this is payload ---------------------"

  ##FLIGHTS
	@flight = Flight.new
	@flight.origin = @payload[:origin]
	@flight.destination = @payload[:destination]
	@flight.departs_at = @payload[:departureDate]
	@flight.arrives_at = @payload[:returnDate]
	@flight.num_of_adults = @payload[:numOfPassengers]

	departs_at = @flight.departs_at.to_s.slice(0..9)
	arrives_at = @flight.arrives_at.to_s.slice(0..9)
	num_of_adults = @flight.num_of_adults.to_s

	query_string = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=' + $key + '&origin=' + @flight.origin + '&destination=' + @flight.destination + '&departure_date=' + departs_at + '&return_date=' + arrives_at + '&adults=' + num_of_adults + '&number_of_results=1'

	response = open(query_string).read
	resParsed = JSON.parse(response)
  # binding.pry

	@flight.fare = resParsed["results"][0]["fare"]["total_price"]

	@outbound = OutboundFlight.new
	@outbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["flight_number"]
	if (resParsed["results"][0]["itineraries"][0]["outbound"]["flights"].length != 1)
		@outbound.flight_num_2 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][1]["flight_number"]
	end

	@outbound.airline = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["marketing_airline"]

	@outbound.save

	@inbound = InboundFlight.new
	@inbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["flight_number"]
	if (resParsed["results"][0]["itineraries"][0]["inbound"]["flights"].length != 1)
		@inbound.flight_num_2 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][1]["flight_number"]
	end

	@inbound.airline = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["marketing_airline"]

	@inbound.save

	@flight.outbound_id = @outbound[:id]
	@flight.inbound_id = @inbound[:id]

	 @flight.save


  	##HOTELS
  	@hotel = Hotel.new

  	@hotel.location_code = @payload[:locationCode]

  	@hotel.check_in = @payload[:checkInDate]
  	p @hotel.check_in
  	@hotel.check_out = @payload[:checkOutDate]
  	p @hotel.check_out

  	check_in = @hotel.check_in.to_s.slice(0..9)
  	p check_in
  	check_out = @hotel.check_out.to_s.slice(0..9)
  	p check_out

  	query_string_hotel = 'https://api.sandbox.amadeus.com/v1.2/hotels/search-airport?apikey=' + $key + @hotel.location_code + '&check_in=' + check_in + '&check_out=' + check_out + '&number_of_results=1'

  	pp query_string_hotel
  	response_hotel = open(query_string_hotel).read
  	resParsed_hotel = JSON.parse(response_hotel)



    @hotel.property_name = resParsed_hotel["results"][0]["property_name"]

    street_address = resParsed_hotel["results"][0]["address"]["line1"]
    city = resParsed_hotel["results"][0]["address"]["city"]
    region = resParsed_hotel["results"][0]["address"]["region"]
    postal_code =  resParsed_hotel["results"][0]["address"]["postal_code"]
    country = resParsed_hotel["results"][0]["address"]["country"]


    address = street_address + ", " + city + ", " + region + " " + country + " " + postal_code

    @hotel.address = address

    # binding.pry

    @hotel.total_price = resParsed_hotel["results"][0]["total_price"]["amount"]
    @hotel.booking_code = resParsed_hotel["results"][0]["rooms"][0]["booking_code"]
  	@hotel.save

  	@trip = Trip.new #instantiating a new class from Trip model
  	@trip.title = @payload[:title]
  	@trip.budget = @payload[:budget]
  	@trip.saved = @payload[:amountSaved]
  	@trip.flight_id = @flight[:id]
  	@trip.hotel_id = @hotel[:id]
  	@trip.user_id = session[:user_id]
  	@trip.cost = @flight.fare + @hotel.total_price
  	@trip.save


  	{
  		success: true,
  		message: "Trip #{@trip.title} successfully created",
  		added_trip: @trip,
  	}.to_json

  end


######UPDATE TRIP ROUTE#####
put '/:id'do

	puts ""
	pp @payload
	puts "this is payload"
	puts ""

	@trip = Trip.find params[:id]

	puts ""
	pp @trip
	puts "this is trip"
	puts ""

	# flights

	@flight = Flight.find(@trip[:flight_id])

	puts ""
	pp @flight
	puts "this is flight"
	puts ''

	@flight.origin = @payload[:origin]
	@flight.destination = @payload[:destination]
	@flight.departs_at = @payload[:departureDate]
	@flight.arrives_at = @payload[:returnDate]
	@flight.num_of_adults = @payload[:numOfPassengers]

	departs_at = @flight.departs_at.to_s.slice(0..9)
	arrives_at = @flight.arrives_at.to_s.slice(0..9)
	num_of_adults = @flight.num_of_adults.to_s

	query_string = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=' + $key + 'origin=' + @flight.origin + '&destination=' + @flight.destination + '&departure_date=' + departs_at + '&return_date=' + arrives_at + '&adults=' + num_of_adults + '&number_of_results=1'

	response = open(query_string).read
	resParsed = JSON.parse(response)

	@flight.fare = resParsed["results"][0]["fare"]["total_price"]

	@outbound = OutboundFlight.find(@flight[:outbound_id])
	@outbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["flight_number"]
	if (resParsed["results"][0]["itineraries"][0]["outbound"]["flights"].length != 1)
		@outbound.flight_num_2 = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][1]["flight_number"]
	end

	@outbound.airline = resParsed["results"][0]["itineraries"][0]["outbound"]["flights"][0]["marketing_airline"]

	@outbound.save

	@inbound = InboundFlight.find(@flight[:inbound_id])
	@inbound.flight_num_1 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["flight_number"]
	if (resParsed["results"][0]["itineraries"][0]["inbound"]["flights"].length != 1)
		@inbound.flight_num_2 = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][1]["flight_number"]
	end

	@inbound.airline = resParsed["results"][0]["itineraries"][0]["inbound"]["flights"][0]["marketing_airline"]

	@inbound.save

	@flight.outbound_id = @outbound[:id]
	@flight.inbound_id = @inbound[:id]

	@flight.save


	# HOTEL EDIT
  @hotel = Hotel.find(@trip[:hotel_id])

  @hotel.location_code = @payload[:locationCode]
  @hotel.check_in = @payload[:checkInDate]
  @hotel.check_out = @payload[:checkOutDate]

  check_in = @hotel.check_in.to_s.slice(0..9)
  check_out = @hotel.check_out.to_s.slice(0..9)

  query_string_hotel = 'https://api.sandbox.amadeus.com/v1.2/hotels/search-airport?apikey=' + $key + '&location=' + @hotel.location_code + '&check_in=' + check_in + '&check_out=' + check_out + '&number_of_results=1'

  response_hotel = open(query_string_hotel).read
  resParsed_hotel = JSON.parse(response_hotel)

  @hotel.property_name = resParsed_hotel["results"][0]["property_name"]

  street_address = resParsed_hotel["results"][0]["address"]["line1"]
  city = resParsed_hotel["results"][0]["address"]["city"]
  region = resParsed_hotel["results"][0]["address"]["region"]
  postal_code =  resParsed_hotel["results"][0]["address"]["postal_code"]
  country = resParsed_hotel["results"][0]["address"]["country"]

  address = street_address + ", " + city + ", " + region + " " + country + " " + postal_code

  @hotel.address = address

  @hotel.total_price = resParsed_hotel["results"][0]["total_price"]["amount"]
  @hotel.booking_code = resParsed_hotel["results"][0]["rooms"][0]["booking_code"]
  @hotel.save

	# TRIP EDIT STUFF
	#instantiating a new class from Trip model
	@trip.title = @payload[:title]
	@trip.budget = @payload[:budget]
	@trip.saved = @payload[:amountSaved]
	@trip.flight_id = @flight[:id]
	@trip.hotel_id = @hotel[:id]
	@trip.user_id = session[:user_id]
	@trip.cost = @flight.fare + @hotel.total_price
	@trip.save

	{
		success: true,
		message: "You updated trip \##{@trip.id}",
		updated_trip: @trip,
		flight: @flight,
		hotel: @hotel
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

# END FOR THE CLASS
end
