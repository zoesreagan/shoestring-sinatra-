class Trip < ActiveRecord::Base
	belongs_to :user
	has_one :hotel
	has_one :flight
end