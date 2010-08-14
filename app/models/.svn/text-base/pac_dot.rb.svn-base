class PacDot < ActiveRecord::Base
  belongs_to :game

  before_create :init_fields

  def init_fields
    if self.isPowerup == nil
      self.isPowerup = false
    end
  end
end
