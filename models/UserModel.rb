class User < ActiveRecord::Base
	has_many :trips, dependent: :destroy
	has_many :hotels, :through => :trips
	has_many :flights, :through => :trips
end
