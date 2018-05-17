# shoestring-sinatra

# Welcome to the Shoestring API. 

This API pulls in external data from the Amadeus Travel Innovation Sandbox Flight Low-Fare Search API and the Amadeus Travel Innovation Sandbox Hotel Airport Search to gather low-cost flights and accommodations for the budget-conscious millennial traveler. 

You can access the following routes on the Shoestring API: 

## USER 

### 1. "../user/" <- Get the user who is currently logged in (GET)

If the request was successful, the API will return the following message: 

{<br />
    success: true, <br />
    message: "Found user #{@user.id}", <br />
    found_user: @user <br />
}

### 2. "../user/register" <- Register a new user (POST)

If the desired username is already taken, the API will return the following message: 

{<br />
    success: false, <br />
    message: "username already taken, try again" <br />
}

If registration was successful, the API will return the following message: 

{ <br />
    success: true, <br />
    user_id: user.id, <br />
    username: user.username, <br />
    message: "you are logged in and you have a cookie attached to all the responses" <br />
}

### 3. "../user/login" <- Log in to Shoestring (POST)

If login was successful, the API will return the following message: 

{ <br />
    success: true, <br />
    user_name: user.name, <br />
    user_id: user.id, <br />
    username: username, <br />
    message: "Login successful" <br />
}

If login was not successful, the API will return the following message: 

{ <br />
    success: false, <br />
    message: "Invalid Username or password" <br />
}

### 4. "../user/:id" <- Edit an existing user (PUT)

If the attempt to edit a user's account was successful, the API will return the following message: 

{ <br />
    success: true, <br />
    message: "User was successfully updated" <br />
}

If the new desired username has already been taken, the API will return the following message: 

{ <br />
    success: false, <br />
    message: "username already taken, try again" <br />
}


### 5. "../user/logout" <- Log out of Shoestring (GET)

If the user was successfully logged out, the API will return the following message: 

{ <br />
    success: true, <br />
    message: "you are logged out" <br />
}

## TRIPS 

The user must be logged in to access their trips. If the user tries to hit any of the trip routes without being logged in to Shoestring, the API will return the following message: 

{ <br />
    success: false, <br />
    message: "you are not logged in" <br />
}

### 1. "../trips/" <- Get all the trips for the current user (GET)

If the request is successful, the API will return the following message: 

{ <br />
    success: true, <br />
    trip: @trip <br />
}

This will include a list of all trips belonging to the current user.

### 2. "../trips/:id" <- Get details for a single trip (GET)

If the request is successful, the API will return the following message: 

{ <br />
    success: true, <br />
    trip: @trip, <br />
    flight: @flight, <br />
    outbound: @outbound, <br />
    inbound: @inbound, <br />
    hotel: @hotel <br />
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

### 3. "../trips/" <- Create a new trip (POST)

If the request is successful, the API will return the following message: 

{ <br />
    success: true, <br />
    message: "Trip #{@trip.title} successfully created", <br />
    added_trip: @trip  <br />
}

To ensure all parts of the trip were created, check the added_trip object to make sure that flight_id and hotel_id are *not null.* 

### 4. "../trips/:id" <- Update an existing trip (PUT)

If the request is successful, the API will return the following message: 

{ <br />
    success: true, <br />
    message: "You updated trip \##{trip.id}", <br />
    updated_trip: @trip, <br />
    flight: @flight, <br />
    hotel: @hotel <br />
}

To ensure the trip was updated successfully, check the updated_trip object to make sure that flight_id and hotel_id are *not null.* 

### 5. "../trip/" <- Delete an existing trip (DELETE

If the request is successful, the API will return the following message: 

{ <br />
    success: true, <br />
    message: "trip #{@trip.title} deleted successfully" <br />
}

