class Band < ApplicationRecord
  belongs_to :band, optional: true

  has_many :enemies

  validates :name, presence: true
end
