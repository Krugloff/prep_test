class Punch < ApplicationRecord
  belongs_to :round, required: true, query_constraints: %i(fight_id enemy_id)
 
  belongs_to :fight, required: true
  belongs_to :enemy, required: true
  belongs_to :puppet, required: true, query_constraints: %i(enemy_id puppet_name)

  validates :puppet_name, presence: true
end