class Ring < ApplicationRecord
  belongs_to :band, required: true
  has_many :enemies, through: :band

  has_many :fights, dependent: :restrict_with_error

  # TODO: it is expensive to check this every time
  validates :maximum_score, numericality: { less_than_or_equal_to: :enemies_count }
  validates :treshold, numericality: { in: 0..100 }

  def enemies_count = enemies.count
  def band_name = band.name
end
