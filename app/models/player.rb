class Player < ApplicationRecord
  belongs_to :team
  has_many :event_players, dependent: :destroy
  has_many :events, through: :event_players
  has_many :notifications, dependent: :destroy
  has_one_attached :photo

  HEALTH = %w[Injured Available Limited]

  validates :first_name, :last_name, :position, :birthdate, presence: true
  validates :health, inclusion: { in: HEALTH }
  validates :note, length: { maximum: 1000 }

  def full_name
    "#{first_name} #{last_name}"
  end

  include PgSearch::Model
  multisearchable against: %i[first_name last_name health]
  PgSearch.multisearch_options = {
    using: { tsearch: { prefix: true } }
  }
end
