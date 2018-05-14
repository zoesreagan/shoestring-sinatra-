class UserController < ApplicationController

##index route
    get '/' do
      @users = User.all
      @users.to_json
    end

##create user route
  post '/' do
    payload_body = request.body.read
    payload = JSON.parse(payload_body).symbolize_keys

    @user = User.new
    @user.name = payload[:name]
    @user.photo = payload[:name]
    @user.save
    @user.to_json
    ##username
    ##password

  end

##update user route

  # put ':/id' do
  #   payload_body = request.body.read
  #   @payload = JSON.parse(payload_body).symbolize_keys
  #
  #   @user = User.find params[:id]
  #   @user.name = payload[:name]
  #   #username
  #   #password
  #   #picture
  #   @user.save
  #   {
  #     success: true,
  #     message: "You updated item \##{@waiter.id}",
  #     updated_user: @user
  #   }.to_json
  # end






end
