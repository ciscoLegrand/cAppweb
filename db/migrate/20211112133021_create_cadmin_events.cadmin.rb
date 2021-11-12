# This migration comes from cadmin (originally 20211005131408)
class CreateCadminEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :cadmin_events do |t|
      t.integer :customer_id, null: false, foreign_key: {to_table: :cadmin_users}
      t.integer :employee_id, null: true, foreign_key: {to_table: :cadmin_users}
      t.string :title
      t.string :type_name, null: false, default: 'wedding'
      t.string :number, null: false, unique: true
      t.date :date, null: false
      t.integer :guests 
      t.integer :place_id
      t.float :deposit, null: false, default: 0, precision: 10, scale: 2
      t.float :total_amount, null: false, default: 0, precision: 10, scale: 2
      t.boolean :charged, null: false, default: false
      t.text :observations

      t.timestamps
    end
  end
end
