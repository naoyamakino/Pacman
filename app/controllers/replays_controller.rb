class ReplaysController < ApplicationController
  before_filter :require_no_user, :only => [:redirect]
  before_filter :require_user, :only => [:index, :show]

require 'rexml/document'
include REXML


$isFirstPacMarker = false;
$ghostArray = Array.new(5, 0);
$doesExist = false;
$doesNotExist = false;
$numofGhost = 0

  def index
    @replays = MatchLog.all
	@game = Game.all


  end

  # gets current game ID
  def show
	
	#@current_gid = request.path_parameters['id']
	#generateMap(@current_gid)
	#puts @current_gid
	
	#getCurrentPlayers(@current_gid)

	#puts "LAST ID #{$currentMatchLogID}"
  end

  def gameInfo
	puts "inside gameinfo"
	#@current_gid = request.path_parameters['id']
	doc = request.request_parameters.to_xml
		if(request.xhr?)
			docxml = Document.new(doc)
			root = docxml.root
			game_id = root.elements[1].text
			puts game_id
		end
		returnUpdate = Game.all(:conditions => {:id => game_id})
#returnUpdate = Game.all(:conditions => {:id => @current_gid})
		#render :text => "HOMOSHIT"
		#render :xml => returnUpdate
		render :xml => returnUpdate, :content_type => "text/xml"
		#render :text => "WATCH THIS"

  end


  def test
	returnUpdate = Game.all(:conditions => ["id=?", 4])
	render :xml => returnUpdate

  end


  def matchLog_info
	 doc = request.request_parameters.to_xml
		if(request.xhr?)
			docxml = Document.new(doc)
			root = docxml.root
			game_id = root.elements[1].text
			type = root.elements[2].text
			puts type
		end

		if type == 'pacman'
			returnUpdate = MatchLog.find(:all, :joins => :player, :conditions => {:players =>{:playerType => 'pacman'}})
		elsif type == 'ghost'
			returnUpdate = MatchLog.find(:all, :joins => :player, :conditions => {:players =>{:playerType => 'ghost'}})
		end

		returnUpdate.each_with_index do |x, index|
			puts x.player_id
			puts x.id
			puts x.status

		end

		render :xml => returnUpdate, :content_type => "text/xml"

  end

  def currentType 
	doc = request.request_parameters.to_xml
		if(request.xhr?)
			docxml = Document.new(doc)
			root = docxml.root
			game_id = root.elements[2].text
			player_id = root.elements[1].text
			puts player_id
		end
		returnUpdate = Player.all(:conditions => {:id => player_id})
		#returnUpdate.each_with_index do |p, index|
		#	puts "HELLZ YA #{  p.playerType}"
		#	@type = p.playerType
		#end

		render :xml => returnUpdate


  end 

 def redirect
    redirect_to root_url  
 end





end
