require 'csv'

class Phone < ActiveRecord::Base
  attr_accessible :name, :number
  validates :name, :presence => true
  validates :number, :presence => true
  validates :number, :uniqueness => true

  def self.to_csv
    columns_to_export = ['number', 'name']
    CSV.generate({:col_sep => "\t"}) do |csv|
      csv << columns_to_export
      all.each do |phone|
        csv << phone.attributes.values_at(*columns_to_export)
      end
    end
  end

end
