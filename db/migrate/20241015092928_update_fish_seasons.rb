class UpdateFishSeasons < ActiveRecord::Migration[7.0]
  def change
    add_column :fish_seasons, :start_month, :integer
    add_column :fish_seasons, :start_day, :integer
    add_column :fish_seasons, :end_month, :integer
    add_column :fish_seasons, :end_day, :integer

    remove_column :fish_seasons, :start_date, :date
    remove_column :fish_seasons, :end_date, :date
    remove_index :fish_seasons, [:fish_id, :start_date, :end_date], if_exists: true
    add_index :fish_seasons, [:fish_id, :start_month, :start_day, :end_month, :end_day], unique: true, name: 'index_fish_seasons_on_fish_id_and_dates'
  end
end
