class CreateStationData < ActiveRecord::Migration[5.1]
  def change
    create_table :station_data do |t|
      t.string :station
      t.string :data

      t.timestamps
    end
  end
end
