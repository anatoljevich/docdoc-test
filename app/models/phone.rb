class Phone < ActiveRecord::Base
  attr_accessible :name, :number
  validates :name, :presence => true
  validates :number, :presence => true
  validates :number, :uniqueness => true

  

end
