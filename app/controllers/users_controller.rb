class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(1)
  end

end
