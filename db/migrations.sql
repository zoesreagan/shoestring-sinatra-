DROP DATABASE IF EXISTS shoestring;
CREATE DATABASE shoestring;
\c shoestring;

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	name VARCHAR(128),
	username VARCHAR(64),
	password_digest VARCHAR(256),
	photo VARCHAR(256)
);

CREATE TABLE outbound_flights (
	id SERIAL PRIMARY KEY,
	airline VARCHAR(8),
	flight_num_1 NUMERIC,
	flight_num_2 NUMERIC
);

CREATE TABLE inbound_flights (
	id SERIAL PRIMARY KEY,
	airline VARCHAR(8),
	flight_num_1 NUMERIC,
	flight_num_2 NUMERIC
);

CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	origin VARCHAR(256),
	destination VARCHAR(256),
	departs_at TIMESTAMP,
	arrives_at TIMESTAMP,
	airline VARCHAR(64),
	num_of_adults SMALLINT,
	fare NUMERIC,
	outbound_id INT REFERENCES outbound_flights(id),
	inbound_id INT REFERENCES inbound_flights(id)
);

CREATE TABLE hotels(
	id SERIAL PRIMARY KEY,
	location_code VARCHAR(32),
	property_name  VARCHAR(64),
	address VARCHAR(512),
	check_in DATE,
	check_out DATE,
	total_price NUMERIC,
	booking_code VARCHAR(32)
);

CREATE TABLE trips(
	id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(id),
	title VARCHAR(256),
	cost SMALLINT,
	budget SMALLINT,
	saved NUMERIC,
	hotel_id INT REFERENCES hotels(id),
	flight_id INT REFERENCES flights(id)
);
