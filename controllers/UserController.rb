class UserController < ApplicationController

	before do
			puts $key
	    payload_body = request.body.read
	    if(payload_body != "")
	      @payload = JSON.parse(payload_body).symbolize_keys
	    end
	end

	get '/' do
		@user = User.find(session[:user_id])

		{
			success: true,
			message: "Found user #{@user.id}",
			found_user: @user
		}.to_json
	end

	post '/register' do
	  	user = User.new

	  	user.name = @payload[:name]
	  	user.username = @payload[:username]
	  	user.password = @payload[:password]
	  	user.photo = @payload[:photo]

	  	userExist = User.find_by username: user.username
	  	if userExist
	  		{
	  			success: false,
	  			message: "username already taken, try again"
	  		}.to_json
	  	else
		  	user.save
		  	session[:logged_in] = true
		  	session[:name] = user.name
		  	session[:username] = user.username
		  	session[:user_id] = user.id
		  	session[:photo] = user.photo
		  	{
		  		success: true,
		  		user_id: user.id,
			  	username: user.username,
		  		message: 'you are logged in and you have a cookie attached to all the responses'
	  		}.to_json
		end

	end

	post '/login' do
	  	username = @payload[:username]
	  	password = @payload[:password]
	  	user = User.find_by username: username
	  	if user && user.authenticate(password)
	  		session[:logged_in] = true
	  		session[:name] = user.name
	  		session[:username] = username
	  		session[:user_id] = user.id
	  		session[:photo] = user.photo
		  	{
		  		success: true,
		  		user_name: user.name,
		  		user_id: user.id,
		  		username: username,
		  		message: 'Login succsesful'
		  	}.to_json
	  	else
	  		{
	  			success: false,
	  			message: 'Invalid Username or password'
	  		}.to_json
	  	end
  	end

  	get '/logout' do
	  	session.destroy
	  	{
	  		success: true,
	  		message: "you are logged out"
	  	}.to_json
  	end

  	put '/:id' do
	    user = User.find(params[:id])
	    user.name = @payload[:name]
	    user.username = @payload[:username]
	    user.password = @payload[:password]
	    user.photo = @payload[:photo]

	    userExist = User.find_by username: user.username
	  	if userExist
	  		{
	  			success: false,
	  			message: "username already taken, try again"
	  		}.to_json
	  	else
		  	user.save
		  	{
		  		success: true,
		  		message: 'User was successfuly updated'
	  		}.to_json
		end

  	end
end
