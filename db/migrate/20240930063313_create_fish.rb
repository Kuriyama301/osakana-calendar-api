class CreateFish < ActiveRecord::Migration[7.0]
  def change
    create_table :fish do |t|
      t.string :name
      t.text :features
      t.text :nutrition
      t.string :origin

      t.timestamps
    end
  end
end
