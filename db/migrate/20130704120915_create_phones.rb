class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number, :limit => 16
      t.string :name
      t.timestamps
    end
    add_index :phones, :number, :unique => true
  end
end
