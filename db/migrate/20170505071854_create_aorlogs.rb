class CreateAorlogs < ActiveRecord::Migration
  def change
    create_table :aorlogs do |t|
      t.integer :cnt 
      t.timestamps null: false
    end
  end
end
