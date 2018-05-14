DROP DATABASE IF EXISTS shoestring;
CREATE DATABASE shoestring;
\c shoestring;

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username VARCHAR(128),
	name VARCHAR(128),
	photo VARCHAR(256)
);

CREATE TABLE flights(
	id SERIAL PRIMARY KEY,
	origin VARCHAR(256),
	destination VARCHAR(256),
	departs_at TIMESTAMP,
	arrives_at TIMESTAMP,
	airline VARCHAR(64),
	num_of_adults SMALLINT,
	flight_num VARCHAR(64),
	fare NUMERIC
);

CREATE TABLE hotels(
	id SERIAL PRIMARY KEY,
	location_code VARCHAR(32),
	location VARCHAR,
	check_in DATE,
	check_out DATE,
	num_of_rooms SMALLINT,
	price NUMERIC
);

CREATE TABLE trips(
	id SERIAL PRIMARY KEY,
	title VARCHAR(256),
	-- cost sum of fare + price ,
	budget SMALLINT,
	saved NUMERIC,
	hotel_id INT REFERENCES hotels(id),
	flight_id INT REFERENCES flights(id)
);
