class CreateDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :deliveries do |t|
      t.string :method
      t.decimal :price
      t.string :duration

      t.timestamps
    end
  end
end
