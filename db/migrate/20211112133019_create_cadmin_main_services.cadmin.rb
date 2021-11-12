# This migration comes from cadmin (originally 20211005131156)
class CreateCadminMainServices < ActiveRecord::Migration[6.1]
  def change
    create_table :cadmin_main_services do |t|
      t.string :name
      t.text :description
      t.integer :position

      t.timestamps
    end
  end
end
