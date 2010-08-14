include REXML
include ActionView::Helpers::NumberHelper
require 'rexml/document'

class GamesController < ApplicationController
  before_filter :require_user

  # Error constants #
  GAME_SERVER_ERROR = 0 
  INVALID_REQUEST = -1
  GAME_NOT_STARTED = -2
  GAME_DONE = -3
 
  #GET /games
  def index
    @games = Game.all(:conditions => [ "status = ?", Game::OPEN ])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  #GET /games/new
  def new
    @game = Game.new
   end

  #GET /games/:id
  def show
    @game = Game.find(params[:id])
     
    #place_dots
    respond_to do |format|
      format.html # index.html.erb
    end
   end

  def create
    @map = GMap.new("map_div")
    @game = Game.new(params[:game])
    @game.status = Game::OPEN

    if @game.save
      redirect_to games_path
    else
      render :action => 'new', :layout => "games_new"
    end
  end

  def join
    begin
      game = Game.find( params[:id] , :lock => true) #Lock to prevent race condition of two people trying to join.
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Trying to join a non-existent game"
      redirect_to games_path
      return
    end

    if game.isPrivate && params[:password] == nil
      render :template => "games/password"
      game.save 
      return
    else
      # If password valid?
      if game.isPrivate && !game.match_password?(params[:password])
        flash[:error] = "Sorry, wrong password."
        game.save
        redirect_to games_path
        return
      end

      # Attempt to join the game.
      if game.players.find(:first, :conditions => [ "user_id = ?", current_user.id ]) != nil && game.status != Game::DONE
	game.save #Release the lock.
        redirect_to :action => "play", :id => params[:id]
      elsif game.status == Game::OPEN && game.players.count < 5
        if game.players.count == 0
          game.players << Player.create(:user_id => current_user.id, :playerType => "Pacman", :status => Player::NOTREADY, :ghosts_eaten => 0)
        else
          game.players << Player.create(:user_id => current_user.id, :playerType => "Ghost", :status => Player::NOTREADY, :ghosts_eaten => 0)
        end
        
        game.save #Release the lock.
        redirect_to :action => "play", :id => params[:id]
      else
        if game.status != Game::OPEN
          flash[:error] = "Sorry, this game is no longer open for players."
        else
          flash[:error] = "Sorry, but this game is full."
        end

        game.save #Release the lock.
        redirect_to games_path
      end
    end
  end

  def play
    # If the request is an xhr request, we do the game logic here.
    doc = request.request_parameters.to_xml
    if request.xhr?

        # Parse the xhr request and get the expected components.
        docxml = Document.new(doc)
        root = docxml.root
        game_id = root.elements[1].text
        lat = root.elements[2].text.to_f
        long = root.elements[3].text.to_f
        game = nil
        curPlayer = nil

        # Retrieve game and player to update.
        begin 
          game = Game.find(game_id)
          curPlayer = game.players.find(:first, :conditions => [ "user_id = ?", current_user.id ])
        rescue ActiveRecord::RecordNotFound
          render :xml => doXMLError(INVALID_REQUEST, "Not a valid game/player.")
          return
        end

        if !requestIsValid?(curPlayer, lat, long)
          render :xml => doXMLError(INVALID_REQUEST, "Update parameters are invalid.")        
          return
        end

        # Otherwise, save position update.
        curPlayer.lat = lat
        curPlayer.long = long
        if !curPlayer.save
          render :xml => doXMLError(GAME_SERVER_ERROR, "Failed to save position update!")
          return
        end

        if (game.status == Game::OPEN || game.status == Game::NEW) && (curPlayer.playerType != Player::PACMAN)
          render :xml => doXMLError(GAME_NOT_STARTED, "Game has not yet started. Ensure you are within the game boundaries.")
          return
        elsif game.status == Game::DONE
          render :xml => doXMLError(GAME_DONE, "Game has already finished")          
          return
        else

	  # If game hasn't started yet, and we're pacman, see if we can start the game. 
 	  if game.status == Game::OPEN && curPlayer.playerType == Player::PACMAN
	    if !game.start?
              render :xml => doXMLError(GAME_NOT_STARTED, "Game has not yet started. Ensure you are within the game boundaries.")
	      return
            end 

          # If player is dead...#
          elsif curPlayer.status == Player::DEAD
            render :xml => doXMLError(INVALID_REQUEST, "You're dead!")
          end

	  # Only save if game has already started.
          game.match_logs << MatchLog.create(:player_id => curPlayer.id, :status => curPlayer.status, :lat => lat, :long => long) #Log entry.

          # Update local fields in Player.
          curPlayer.lat = lat
          curPlayer.long = long
          if !curPlayer.save
            render :xml => doXMLError(GAME_SERVER_ERROR, "Failed to save position update!")
            return
          end

          # Now, collision checks. The collision check will auto-update status of the curPlayer if necessary.
          # To avoid concurrency issues, players can only update their own status.
          game.players.each do |op|
	    op.checkPowerupExpiry # Do this check for all players (sync'ed method).
            if op.id != curPlayer.id
              curPlayer.collisionCheckPlayer(op)
            end
          end

          # Either we don't care about objects (I AM A GHOST!), or we're dead and we can't care about anything ;_;
          if !game.checkWithinBoundaries?(curPlayer)

            # If you haven't moved back in bounds since your last update, we kill you. Literally.
            if curPlayer.status == Player::OUT_OF_BOUNDS 
              curPlayer.status = Player::DEAD
            elsif curPlayer.status != Player::DEAD
              curPlayer.status = Player::OUT_OF_BOUNDS
            end

            curPlayer.save

          elsif curPlayer.status != Player::DEAD && curPlayer.playerType == "Pacman"
            if curPlayer.status == Player::OUT_OF_BOUNDS
              curPlayer.status = Player::ALIVE
              curPlayer.save
            end
 
            gameObjects = game.pac_dots.find(:all, :conditions => {:is_eaten => false})
            gameObjects.each do |dot|
              curPlayer.collisionCheckObject(dot)
            end
          end
        end

        # Finally, check game status and send the response.
	if curPlayer.status == Player::DEAD  && curPlayer.playerType == Player::PACMAN
          game.players.each do |op|
	    if op.id != curPlayer.id
              op.user.stat.games_won_as_ghost += 1
              op.user.stat.save
            end
          end

          game.status == Game::DONE
          game.save

        elsif game.pac_dots.find(:all, :conditions => {:is_eaten => false}).count  == 0 && curPlayer.playerType == Player::PACMAN
          curPlayer.user.stat.games_won_as_pacman += 1
          curPlayer.user.stat.save

          game.status = Game::DONE # Game is done.
          game.save
        end

	# Respond with game update.
        render :xml => doXML(game)
     else
       # Render the HTML view (first load). 
       begin
         game = Game.find( params[:id] , :lock => true) #Lock to prevent race condition of two people trying to join.
         curPlayer = game.players.find(:first, :conditions => [ "user_id = ?", current_user.id ])
 
         if curPlayer == nil
           flash[:error] = "You're not authorized to play this game. Join the game through the game browser."
           game.save # Make sure we release the lock.
           redirect_to games_path
         end

         game.save # Everything was fine.
       rescue ActiveRecord::RecordNotFound
         flash[:error] = "Cannot join the game: invalid game/unauthorized."
         redirect_to games_path
         return
       end
     end
  end

  def toggleReady
    doc = request.request_parameters.to_xml
    if request.xhr?
      docxml = Document.new(doc)
      root = docxml.root
      game_id = root.elements[1].text    

      game = Game.find(game_id)
      curPlayer = game.players.find(:first, :conditions => [ "user_id = ?", current_user.id ])
      if curPlayer.status == Player::READY
        curPlayer.status = Player::NOTREADY
      elsif curPlayer.status == Player::NOTREADY
        curPlayer.status = Player::READY
      end
   
      curPlayer.save 
      render :xml => doXMLStatus(curPlayer)
    end    
  end

  private
  def doXMLError(id, error_msg)
    @xml = Builder::XmlMarkup.new
 
    @xml.instruct!
    @xml.errors {
      @xml.error_id(id)
      @xml.error(error_msg)
    }    
  end

  def doXML(game)
    @xml = Builder::XmlMarkup.new

    @xml.instruct!
    @xml.entities {
      @xml.boundaries do
        @xml.lat(game.latitude)
        @xml.long(game.longitude)
        @xml.lat2(game.latitude2)
        @xml.long2(game.longitude2)
      end

      for p in game.players
        if p.status != "DEAD"
          @xml.player do
            @xml.id(p.user.username)
	    @xml.lat(p.lat)
            @xml.long(p.long)
            @xml.type(p.playerType)
            @xml.status(p.status)
          end
        end
      end
 
      for d in game.pac_dots.find(:all, :conditions => {:is_eaten => false})
        @xml.dot do
          @xml.id(d.id)
          @xml.lat(d.latitude)
          @xml.long(d.longitude)
          @xml.isPowerup(d.isPowerup)
        end
      end
    }
  end 

  def doXMLStatus(player)
    @xml = Builder::XmlMarkup.new
    
    @xml.player {
      @xml.status(player.status)
    }
  end
  
  def requestIsValid?(curPlayer, lat, long)
      # Either not a valid game_id, the user is not logged in, and/or player_id is not valid.
      if curPlayer == nil
        return false
      elsif ( !numeric?(lat) || lat.abs > 90 ) || ( !numeric?(long) || long.abs > 180 )
        return false
      end

      return true;
  end

  def numeric?(object)
    true if Float(object) rescue false
  end
end
