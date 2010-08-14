class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end

  # Add username length check.
  validates_length_of :within => 3..15 #Limit length to 15 characters max.
  validates_format_of :username, :with => /^[a-zA-Z0-9]+$/, :message => "can only have characters and numbers with no spaces"
  # Add username character check. 

  has_many :players
  has_one :avatar
  has_one :stat
  has_many :achievements

  before_save :check_optional_fields
  before_create :create_stat_entry

  def check_optional_fields
    if self.country == nil || self.country.strip.length == 0
      self.country = "Neverland"
    end

    if self.province == nil || self.province.strip.length == 0
      self.province = "Pixie Hollow"
    end
  end

  def deliver_password_reset_instructions
    reset_perishable_token!
    Notifier.deliver_password_reset_email(self)
  end

  def create_stat_entry
    self.stat = Stat.new

    self.stat.games_won_as_ghost = 0
    self.stat.games_won_as_pacman = 0
    self.stat.total_ghosts_eaten = 0
    self.stat.total_pacman_eaten = 0
    self.stat.total_distance = 0
    self.stat.save
  end
end
