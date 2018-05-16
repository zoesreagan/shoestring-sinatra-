class Flight < ActiveRecord::Base
	belongs_to :trip
	has_one :outbound_flight
	has_one :inbound_flight
end
