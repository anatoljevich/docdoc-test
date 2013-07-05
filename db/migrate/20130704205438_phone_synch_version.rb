class PhoneSynchVersion < ActiveRecord::Migration
  def up
    add_column :phones, :synch_version, :integer, :default => 0
  end

  def down
    remove_column :phones, :synch_version
  end
end
