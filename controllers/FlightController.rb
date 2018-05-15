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
		# url = URI.parse('http://api.sandbox.amadeus.com/v1.2/flights/low-fare-search?origin=IST&destination=BOS&departure_date=2015-10-15&return_date=2015-10-21&number_of_results=3&apikey=CsAYiUDotu5fFRg8Gl7WFv4AFCqSxRhQ')
		# req = Net::HTTP::Get.new(url.to_s)
		# res = Net::HTTP.start(url.host, url.port) {|http|
		# 	http.request(req)
		# }

		# puts res.body
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