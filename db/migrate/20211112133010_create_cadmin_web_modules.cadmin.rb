# This migration comes from cadmin (originally 20210907195017)
class CreateCadminWebModules < ActiveRecord::Migration[6.1]
  def change
    create_table :cadmin_web_modules do |t|
      t.boolean :blog
      t.boolean :gallery
      t.boolean :mailbox
      t.boolean :opinions
      t.boolean :newsletter
      t.boolean :reservation
      t.boolean :social_media
      t.boolean :invitable
      t.boolean :paypal
      t.boolean :stripe
      t.boolean :multisafe

      t.timestamps
    end
  end
end
