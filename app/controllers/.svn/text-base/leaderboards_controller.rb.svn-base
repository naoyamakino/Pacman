class LeaderboardsController < ApplicationController
  before_filter :require_no_user, :only => [:redirect]
  before_filter :require_user, :only => [:index]
  # GET /leaderboards
  # GET /leaderboards.xml
  def index
    @leaderboards = Stat.all(:order => "points DESC", :limit => 10)

  end
   def redirect
    redirect_to root_url  
 end

 

 
end
