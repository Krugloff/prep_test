class CreateEnemies < ActiveRecord::Migration[7.1]
  def change
    create_table :enemies do |t|
      t.string :language, default: 'en'
      t.belongs_to :band, null: false, foreign_key: { on_delete: :cascade }
      t.string :title, null: false
      t.text :body, default: ''
      t.text :comment, null: false

      t.timestamps
    end
  end
end
