require 'net/http'
require 'open-uri'

class FlightController < ApplicationController 

	before do
    	payload_body = request.body.read
    	if(payload_body != "")
    	@payload = JSON.parse(payload_body).symbolize_keys
    	#parsing the payload body as JSON and converting keys to hashes
		end
	end

	get '/' do
		@flights = Flight.all
		@flights.to_json
	end

	get '/:id' do 
		@flight = Flight.find params[:id]
		departs_at = @flight.departs_at.to_s.slice(0..9)
		arrives_at = @flight.arrives_at.to_s.slice(0..9)
		num_of_adults = @flight.num_of_adults.to_s

		# query_string = 'http://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?origin=' + @flight.origin + '&destination=' + @flight.destination + '&departure_date=' + departs_at + '&return_date=' + arrives_at + '&number_of_results=3&apikey=CsAYiUDotu5fFRg8Gl7WFv4AFCqSxRhQ'

		query_string = 'https://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?apikey=CsAYiUDotu5fFRg8Gl7WFv4AFCqSxRhQ&origin=' + @flight.origin + '&destination=' + @flight.destination + '&departure_date=' + departs_at + '&return_date=' + arrives_at + '&adults=' + num_of_adults

		pp query_string


		# url = URI.parse(query_string)
		# req = Net::HTTP::Get.new(url.to_s)
		# res = Net::HTTP.start(url.host, url.port) {|http|
		# 	http.request(req)
		# }

		# puts res.body

		response = open(query_string).read

		# puts response.to_json
	end

	post '/' do

		puts @payload, 'this is payload in flights'

		@flight = Flight.new
		@flight.origin = @payload[:origin]
		@flight.destination = @payload[:destination]
		@flight.departs_at = @payload[:departureDate]
		@flight.arrives_at = @payload[:returnDate]
		@flight.num_of_adults = @payload[:numOfPassengers]
		@flight.save

		{
			success: true,
			message: "Flight to #{@flight.destination} successfully created",
			added_flight: @flight
		}.to_json

	end

end