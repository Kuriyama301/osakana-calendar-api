class CreateFishSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :fish_seasons do |t|
      t.references :fish, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end

    add_index :fish_seasons, [:fish_id, :start_date, :end_date]
  end
end
