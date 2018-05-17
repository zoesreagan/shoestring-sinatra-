# shoestring-sinatra

# Welcome to the Shoestring API. 

This API pulls in external data from the Amadeus Travel Innovation Sandbox Flight Low-Fare Search API and the Amadeus Travel Innovation Sandbox Hotel Airport Search to gather low-cost flights and accommodations for the budget-conscious millennial traveler. 

You can access the following routes on the Shoestring API: 

## USER 

### * "../user/" <- Get the user who is currently logged in (GET)

If the request was successful, the API will return the following message: 

{
	success: true,
	message: "Found user #{@user.id}",
	found_user: @user
}

### * "../user/register" <- Register a new user (POST)

If the desired username is already taken, the API will return the following message: 

{
	success: false,
	message: "username already taken, try again"
}

If registration was successful, the API will return the following message: 

{
	success: true,
	user_id: user.id,
	username: user.username,
	message: "you are logged in and you have a cookie attached to all the responses"
}

### * "../user/login" <- Log in to Shoestring (POST)

If login was successful, the API will return the following message: 

{
	success: true,
	user_name: user.name,
	user_id: user.id,
	username: username,
	message: "Login successful"
}

If login was not successful, the API will return the following message: 

{
	success: false,
	message: "Invalid Username or password"
}

### * "../user/:id" <- Edit an existing user (PUT)

If the attempt to edit a user's account was successful, the API will return the following message: 

{
	success: true,
	message: "User was successfully updated"
}

If the new desired username has already been taken, the API will return the following message: 

{
	success: false,
	message: "username already taken, try again"
}


### * "../user/logout" <- Log out of Shoestring (GET)

If the user was successfully logged out, the API will return the following message: 

{
	success: true,
	message: "you are logged out"
}

TRIPS 

The user must be logged in to access their trips. If the user tries to hit any of the trip routes without being logged in to Shoestring, the API will return the following message: 

{
	success: false,
	message: "you are not logged in"
}

### * "../trips/" <- Get all the trips for the current user (GET)

If the request is successful, the API will return the following message: 

{
	success: true,
	trip: @trip
}

This will include a list of all trips belonging to the current user.

### * "../trips/:id" <- Get details for a single trip (GET)

If the request is successful, the API will return the following message: 

{
	success: true,
	trip: @trip,
	flight: @flight,
	outbound: @outbound,
	inbound: @inbound,
	hotel: @hotel
}

This response object will contain details about the user's trip. The data is structured as follows: 

	trip: {
		id: id //Unique identifier for each trip
		user_id: users(id) //Pulls in the user's id relation from the database
		title: title //Name of the trip
		cost: cost //Total price of airfare and hotel for this trip
		budget: budget //How much the user plans to spend on this trip
		saved: saved //amount the user has currently saved to put towards this trip
		hotel_id: hotels(id) //Pulls in the hotel id relation from the database
		flight_id: flights(id) //Pulls in the flight id relation from the database
	}

	flight: {
		id: id //Unique identifier for each flight
		origin: origin //Departure airport - MUST BE WRITTEN AS AN AIRPORT CODE per Amadeus Low-Fare Flight Search API requirements
		destination: destination //Arrival airport - MUST BE WRITTEN AS AN AIRPORT CODE per Amadeus Low-Fare Flight Search API requirements
		departs_at: date //Date of departure - MUST BE ENTERED IN THE FOLLOWING FORMAT: YYYY-MM-DD per Amadeus Low-Fare Flight Search API requirements
		arrives_at: date //Date of return - MUST BE ENTERED IN THE FOLLOWING FORMAT: YYYY-MM-DD per Amadeus Low-Fare Flight Search API requirements
		airline: airline //Operating airline for best flight option - generated in response from Amadeus Low-Fare Flight Search API
		num_of_adults: num //number of adult passengers
		fare: fare //Total fare for best flight option - generated in response from Amadeus Low-Fare Flight Search API
		outbound_id: //Pulls in the identifier for outbound flight relation from the database
		inbound_id: //Pulls in the identifier for inbound flight relation from the database
	}

	outbound: {
		id: id //Unique identifier for each outbound flight
		airline: airline //Operating airline for best flight option - generated in response from Amadeus Low-Fare Flight Search API
		flight_num_1: num //Flight number for first leg of best flight option - generated in response from Amadeus Low-Fare Flight Search API
		flight_num_2: num //Flight number for second leg of best flight option - generated in response from Amadeus Low-Fare Flight Search API. Will not populate if the best flight option is nonstop.
	}

	inbound: {
		id: id //Unique identifier for each inbound flight
		airline: airline //Operating airline for best flight option - generated in response from Amadeus Low-Fare Flight Search API
		flight_num_1: num //Flight number for first leg of best flight option - generated in response from Amadeus Low-Fare Flight Search API
		flight_num_2: num //Flight number for second leg of best flight option - generated in response from Amadeus Low-Fare Flight Search API. Will not populate if the best flight option is nonstop.
	}

	hotel: {
		id: id //unique identifier for each hotel
		location_code: location //Hotel location - MUST BE WRITTEN AS AN AIRPORT CODE per Amadeus Hotel Airport Search API requirements
		property_name: name //Name of best/cheapest hotel property as returned from the Amadeus Hotel API
		address: address //Address of best/cheapest hotel property as returned from the Amadeus Hotel API
		check_in: date //Date of check-in - MUST BE ENTERED IN THE FOLLOWING FORMAT: YYYY-MM-DD per Amadeus Hotel Airport Search API requirements
		check_out: date //Date of check-out - MUST BE ENTERED IN THE FOLLOWING FORMAT: YYYY-MM-DD per Amadeus Hotel Airport Search API requirements
		total_price: price //Total price for best hotel option - generated in response from Amadeus Hotel Airport Search API
		booking_code: code //Booking code for best hotel option - generated in response from Amadeus Hotel Airport Search API
	}

### * "../trips/" <- Create a new trip (POST)

If the request is successful, the API will return the following message: 

{
	success: true,
	message: "Trip #{@trip.title} successfully created",
	added_trip: @trip 
}

To ensure all parts of the trip were created, check the added_trip object to make sure that flight_id and hotel_id are *not null.* 

### * "../trips/:id" <- Update an existing trip (PUT)

If the request is successful, the API will return the following message: 

{
	success: true,
	message: "You updated trip \##{trip.id}",
	updated_trip: @trip,
	flight: @flight,
	hotel: @hotel
}

To ensure the trip was updated successfully, check the updated_trip object to make sure that flight_id and hotel_id are *not null.* 

### * "../trip/" <- Delete an existing trip (DELETE

If the request is successful, the API will return the following message: 

{
	success: true,
	message: "trip #{@trip.title} deleted successfully"
}

