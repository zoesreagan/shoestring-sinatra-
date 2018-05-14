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
	  	session[:user_name] = user.name
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

	post '/login' do
	  	puts ''
	  	puts "login. hitting session"
	  	pp session
	  	puts ''


	  	username = @payload[:username]
	  	password = @payload[:password]

	  	user = User.find_by username: username

	  	if user && user.authenticate(password)
	  		session[:logged_in] = true
	  		session[:name] = user.name
	  		session[:username] = username
	  		session[:user_id] = user.id

	  		puts ''
		  	puts "here is session in login after logging in"
		  	pp session
		  	puts ''
		  	{
		  		succses: true,
		  		user_name: user.name,
		  		user_id: user.id,
		  		username: username,
		  		message: 'Login succsesful'
		  	}.to_json
	  	else
	  		{
	  			succses: false,
	  			message: 'Invalid Username or pw'
	  		}.to_json
	  	end
  	end

end