class CreateRings < ActiveRecord::Migration[7.1]
  def change
    create_table :rings do |t|
      t.belongs_to :band, null: false, foreign_key: { on_delete: :cascade }
      t.integer :maximum_score, null: false # maximum enemies you can fight
      t.integer :treshold, default: 75 # percents

      t.timestamps
    end
  end
end
