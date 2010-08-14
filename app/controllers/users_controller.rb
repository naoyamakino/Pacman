class UsersController < ApplicationController
before_filter :require_no_user, :only => [:new, :create]
before_filter :require_user, :except => [:new, :create]

  # GET /users
  # GET /users.xml
  def index
    @user = current_user
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @user = User.find(:first, :conditions => [ "username = ?", params[:id] ])

    if @user == nil
      flash[:error] = "User does not exist."
      redirect_to :action => 'index'
      return
    end
  end

  def edit
    @user = current_user
  end
 
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account has been updated"
      redirect_to :action => 'show', :id => @user.username
    else
      render(:action => 'edit')
    end
  end

  def new  
    if current_user 
      redirect_to users_url    
    else
      @user = User.new
      render :layout => "nouser"
    end
  end  
  
  def create 
   if current_user
     redirect_to users_url
   else
     @user = User.new(params[:user])  
     if @user.save  
      flash[:notice] = "Registration successful."  
      redirect_to users_url  
     else  
      render :layout => "nouser", :action => 'new'  
     end  
   end
  end  

   def destroy
    @user = current_user
    User.destroy(@user)
    flash[:notice] = "You're account has been deleted. :("
    redirect_to(root_url)
  end
end
