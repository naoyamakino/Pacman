require 'digest/sha2'
class Game < ActiveRecord::Base
  ENCRYPT = Digest::SHA512
  has_many :players
  has_many :match_logs
  has_many :pac_dots

  validates_length_of :name, :minimum => 2, :message => "Please enter a game name smaller than 255 characters.", :on => :create
  validates_length_of :name, :maximum => 50, :message => "Please enter a game name longer than 2 characters.", :on => :create
  validates_uniqueness_of :name, :case_sensitive => false, :message => "There is currently a game with the same name. Please enter a new game name."
  
  before_create :init_fields
  after_create :init_dots

  # DB Constants #
  NEW = "NEW" # Unused.
  OPEN = "OPEN"
  ONGOING = "ONGOING"
  DONE = "DONE"

  def init_fields
    self.status = OPEN
    if self.password != nil && self.password.strip.length > 0
      self.salt = [Array.new(9){rand(256).chr}.join].pack('m').chomp
      self.password = ENCRYPT.hexdigest(password + self.salt)
      self.isPrivate = 1
    end
  end

  def init_dots
    num_dots = 10
    if self.hasPowerups
      # Create one powerup.
      create_dot(true)
      num_dots -= 1
    end 

    for i in (1..num_dots)
      create_dot
    end
  end  

  def match_password?(password)
    return self.password == ENCRYPT.hexdigest(password + self.salt)
  end

  def start?
    if self.players.count < 1 # Change to 2 players minimum first. For now ... allow one man testing!
      return false
    end

    if self.status == ONGOING
      return true
    end

    for player in self.players
      if player.status != "RDY" || !checkWithinBoundaries?(player)
        return false
      end
    end
 
    # Everyone was ready when we looked at everyone.  
    for player in self.players
      if player.playerType == Player::PACMAN
        player.status = "PWRUP"
        player.expiry = Time.now + (60 * 2)
      else
        player.status = "ALIVE"
      end  	
      
      player.save
    end

    self.status = ONGOING
    self.save

    return true
  end

  # I'm just going to assume that whoever put the two lat/long points in the db didn't order it.
  def checkWithinBoundaries?(player)
    # Is this necessary (abs'ing for range)
    lat = self.latitude
    long = self.longitude
    lat2 = self.latitude2
    long2 = self.longitude2

    if !player.positioned?
      return false
    end

    if (lat > lat2)
      temp = lat2
      lat2 = lat
      lat = temp
    end

    if (long > long2)
      temp = long2
      long2 = long
      long = temp
    end
   
    if (player.lat >= lat && player.lat <= lat2) && (player.long >= long && player.long <= long2)
      return true
    else
      return false
    end
  end

  private
  def create_dot(isPowerup = false)
        x = generate_rand(self.latitude,self.latitude2)
        y = generate_rand(self.longitude, self.longitude2)
        self.pac_dots << PacDot.create(:latitude => [self.latitude,self.latitude2].min + x, :longitude => [self.longitude, self.longitude2].min + y, :is_eaten => false, :isPowerup => isPowerup)
  end

  def generate_rand(x,y)
        i = (x-y).abs
        j = round_to(i,6)
        until ((r = rand) < j)
        end
        return round_to(r,5)
  end

  def round_to(f,x)
        return (f * 10**x).round.to_f / 10**x
  end
end
