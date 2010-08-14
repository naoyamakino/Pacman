class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]  

  def new
	if current_user
	  redirect_to games_path
	else
        #If logged in, redirect to games.
  	  @user_session = UserSession.new
	  render :layout => "nouser"
	end
  end 
  def create
	@user_session = UserSession.new(params[:user_session]) 
	if current_user
	  redirect_to games_path
	elsif @user_session.save
	  flash[:notice] = "Successfully logged in."
	  session[:user_id] = @user_session.username   
	  redirect_to games_path
	else
	  render :layout => "nouser", :action => "new"
	end
  end 
  def destroy 
	@user_session = UserSession.find 
	@user_session.destroy
  	flash[:notice] = "Successfully logged out."  
	redirect_to root_url
  end 
end
