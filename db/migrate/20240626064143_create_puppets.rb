class CreatePuppets < ActiveRecord::Migration[7.1]
  def change
    create_table :puppets, primary_key: %i(enemy_id name) do |t|
      t.belongs_to :enemy, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.text :body, null: false
      t.boolean :correct, default: false

      t.timestamps
    end
  end
end
