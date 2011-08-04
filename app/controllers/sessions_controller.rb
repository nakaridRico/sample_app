class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end
  
  def create
    render 'new'
  end
end
