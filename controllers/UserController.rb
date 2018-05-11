class UserController < ApplicationController

##index route
    get '/' do
      @users = User.all
      @users.to_json
    end

##add route
  # get '/add' do
  #
  #   @user = User.new
  #   @user.name =
  #   ##username
  #   ##password
  # end





end
