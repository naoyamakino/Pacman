class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  # Types
  PACMAN = "Pacman"
  GHOST = "Ghost"

  # Status
  READY = "RDY"
  NOTREADY = "NRDY"
  ALIVE = "ALIVE"
  DEAD = "DEAD"
  POWERED_UP = "PWRUP"
  OUT_OF_BOUNDS = "OB"

  # Utility function. Is player lat/long defined? #
  def positioned?
    if ( self.lat != nil && numeric?(self.lat) ) && ( self.long != nil && numeric?(self.long) )
      return true
    else
      return false
    end
  end

  # Given a player, check to see if we are in collision with said player. Change status accordingly for both players. 
  def collisionCheckPlayer(player)
    cProximity = 0.0001 # Max 'distance' away permitted for a collision to be recorded.
    
    # If either is dead, there can be no collision. 
    if (player == nil || player.status == DEAD || self.status == DEAD)
      return
    # If this player hasn't done his initial position update yet, don't compare.
    elsif (player.lat == nil || player.long == nil)
      return
    end

    # Check to see if we are in collision.
    if (player.lat - self.lat).abs < cProximity && (player.long - self.long).abs < cProximity

      # Are we Pacman...and did I just collide with a Ghost?
      if self.playerType == PACMAN && player.playerType == GHOST

	# If status is not "PWRUP", then Pacman is normal...we've been eaten ;_;
	if self.status.upcase == ALIVE
	  self.status = DEAD

	  # Statistics update
	  player.user.stat.total_pacman_eaten += 1
          player.user.stat.save
        end

      # Are we a Ghost...and did I just collide with a powered-up Pacman?
      elsif self.playerType == GHOST && player.playerType == PACMAN

	# If Pacman's status is PWRUP...we've been eaten ;_;
	if player.status == POWERED_UP
	  self.status = DEAD

          # Statistics update
          player.user.stat.total_ghosts_eaten += 1
          player.user.stat.save
	end

      end
    end

    self.save
  end

  def collisionCheckObject(pac_dot)
    cProximity = 0.0005 # How sensitive is the collision? Smaller values mean you have to be closer.

    # If player is dead, or pac_dot is eaten there can be no collision.
    if (self.status == DEAD || pac_dot.is_eaten)
      return
    end

    # Check to see if we are in collision.
    if (pac_dot.latitude - self.lat).abs < cProximity && (pac_dot.longitude - self.long).abs < cProximity && !pac_dot.is_eaten
      pac_dot.is_eaten = true
      pac_dot.save

      if pac_dot.isPowerup 
  	  self.expiry = Time.now + (60 * 4) # Set expiry to 3 minutes from now.
	  self.status = POWERED_UP
      end
    end

    self.save
  end

  def checkPowerupExpiry
    self.reload(:lock => true)

    if self.playerType == PACMAN && self.status == POWERED_UP && Time.now.localtime > self.expiry.localtime
        self.status = ALIVE
    end
 
    self.save!
  end
  
  # Move to helper.
  def numeric?(object)
    true if Float(object) rescue false
  end
end
