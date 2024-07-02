class Fight < ApplicationRecord
  belongs_to :ring, required: true
  has_one :band, through: :ring
  has_many :possible_enemies, through: :band, source: :enemies

  has_many :rounds
  has_many :punches, through: :rounds
  has_many :smashed_enemies, through: :punches, source: :enemy

  validates :score, numericality: { in: 0..100 }, allow_nil: true

  def band_name = band.name
  def current_enemy = available_enemies.first
  def rounds_length = rounds.length

  def maximum_score = ring.maximum_score

  private

    def available_enemies = possible_enemies.where.not(id: smashed_enemies.select(:id))
end
