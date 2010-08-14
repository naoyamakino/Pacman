
class MatchLogsController < ApplicationController
before_filter :require_no_user, :only => [:redirect]
before_filter :require_user, :only => [:index]

require 'rexml/document'
include REXML

 def index
   @games = Game.all
   respond_to do |format|
     format.html # index.html.erb
   end
 end

 def update #using the update function to test responses
 end

 def redirect
    redirect_to root_url  
 end

 def new  
 end  

 def create
	doc = request.request_parameters.to_xml
	if (request.xhr?)
		docxml = Document.new(doc)
			#xml processing
			root = docxml.root
			player_id = root.elements[1].text
			game_id = root.elements[2].text
			lat = root.elements[3].text
			long = root.elements[4].text
		#inject into database, need to do some cleanliness checks here
		@match_logs = MatchLog.create(:game_id => game_id, :player_id => player_id, :status => "Normal", :lat => lat, :long => long)
		#injected into database, now what do we need to do? Retrieve records from the database
			returnUpdate = MatchLog.all(:conditions => {:created_at => (Time.now.gmtime - 4.second)..Time.now.gmtime, :game_id => game_id}, :group => "player_id", :select =>"match_logs.lat, match_logs.long, match_logs.player_id, match_logs.status")
			render :xml => returnUpdate
			#render from database complete. Basic notion of gameplay now complete. 
	
	else 	#means the request was not a xhr, renders the standard 404 page to tell people to bugger off
		render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
	end
 end




end
