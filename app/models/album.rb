class Album < ApplicationRecord
  has_many :album_players, dependent: :destroy
  has_many :players, through: :album_players

  validates :name, presence: true
  validates :players, presence: true
end
