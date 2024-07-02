class CreateFights < ActiveRecord::Migration[7.1]
  def change
    create_table :fights do |t|
      t.belongs_to :ring, null: false, foreign_key: { on_delete: :restrict }
      t.integer :score

      t.timestamps
    end
  end
end
