# TODO: what if question body/options will be changed after punch?
class Round < ApplicationRecord
  self.primary_key = %i(fight_id enemy_id)

  belongs_to :fight, required: true
  belongs_to :enemy, required: true

  has_many :punches, query_constraints: %i(fight_id enemy_id)
  has_many :puppets, through: :punches

  validates :punches_length,
    numericality: { equal_to: :required_punches_length, greater_than: 0, if: :enemy_id? }

  after_commit :update_score, on: :create

  def puppet_names=(values)
    return if enemy_id.nil?
    assign_attributes puppet_ids: values.map { [enemy_id, _1] }
  end

  def puppet_names = puppets.map(&:name)

  def win? = puppets.all?(&:correct?)

  private

    def punches_length = punches.length
    def required_punches_length = enemy.hp.to_i

    def update_score
      rounds_length = fight.rounds_length
      return if (0...fight.maximum_score).include?(rounds_length)
      fight.update!(score: (fight.rounds.select(&:win?).size / rounds_length.to_f * 100).to_i)
    end
end
