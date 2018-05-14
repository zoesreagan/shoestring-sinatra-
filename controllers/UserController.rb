class UserController < ApplicationController

	before do
	    payload_body = request.body.read
	    if(payload_body != "")
	      @payload = JSON.parse(payload_body).symbolize_keys
	    end
	end

	post '/register' do
	  	user = User.new

	  	user.name = @payload[:name]
	  	user.username = @payload[:username]
	  	user.password = @payload[:password]
	  	user.save

	  	session[:logged_in] = true
	  	session[:username] = user.username
	  	session[:user_id] = user.id

	  	puts ''
	  	puts 'hitting register rt. here is the session'
	  	pp session
	  	puts''

	  	# here you should check for
	  		# blank input -- send fail
	  		# does this return succes and message
	  	{
	  		succses: true,
	  		user_id: user.id,
	  		user_name: user.name,
		  	username: user.username,
	  		message: 'you are logged in and you have a cookie attached to all the responses'
	  	}.to_json
	end

end