class CreateRound < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds, primary_key: %i(fight_id enemy_id) do |t|
      t.belongs_to :fight, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :enemy, null: false, foreign_key: { on_delete: :restrict }

      t.text :comment

      t.timestamps
    end
  end
end
