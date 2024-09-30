class CreateFishSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :fish_seasons do |t|
      t.references :fish, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
