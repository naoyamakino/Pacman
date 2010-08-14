class Stat < ActiveRecord::Base
  belongs_to :user

  before_save :calc_points

  def calc_points
    self.points = (self.games_won_as_pacman * 4) + (self.games_won_as_ghost * 3) + (self.total_ghosts_eaten * 2) + (self.total_pacman_eaten * 1)
    calc_achievements
  end

  # If any achievements to award (TODO: make a more robust achievement mechanism than static strings logged to a DB)
  # Coming up with names is also interesting. >.>
  def calc_achievements

    #TODO: Use a list of achievements in db with conditions stored in db, iterate and award as necessary. 
    if (self.games_won_as_pacman == 10)
      self.user.achievements << Achievement.create(:name => "The Elusive Pacman", :desc => "Win 10 games as Pacman");
    elsif (self.games_won_as_pacman == 100)
      self.user.achievements << Achievement.create(:name => "Pacman Supreme", :desc => "Win 100 games as Pacman");
    elsif (self.games_won_as_ghost == 10)
      self.user.achievements << Achievement.create(:name => "Pacman Killer", :desc => "Win 10 games as a Ghost");
    elsif (self.games_won_as_ghost == 100)
      self.user.achievements << Achievement.create(:name => "Guardian of all the dots in the world", :desc => "Win 100 games as a Ghost");
    elsif (self.total_ghosts_eaten == 50)
      self.user.achievements << Achievement.create(:name => "Om nom nom!", :desc => "Eat 50 ghosts.");
    elsif (self.total_pacman_eaten == 50)
      self.user.achievements << Achievement.create(:name => "He never saw it coming.", :desc => "Eat 50 Pacman");
    end 
  end
end
