class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.text :data

      t.timestamps
    end
  end
end
