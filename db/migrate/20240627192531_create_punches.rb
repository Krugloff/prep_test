class CreatePunches < ActiveRecord::Migration[7.1]
  def change
    create_table :punches do |t|
      t.belongs_to :enemy, null: false, foreign_key: { on_delete: :restrict }

      t.integer :fight_id, null: false
      t.string :puppet_name, null: false
      t.timestamps

      t.index [:fight_id, :enemy_id, :puppet_name], unique: true

      # TODO: so it's no possible to create punch with wrong puppet name or delete punched puppet?
      t.foreign_key :puppets,
        column: [:enemy_id, :puppet_name],
        primary_key: [:enemy_id, :name],
        on_delete: :restrict

      t.foreign_key :rounds,
        column: [:fight_id, :enemy_id],
        primary_key: [:fight_id, :enemy_id],
        on_delete: :cascade
    end
  end
end
