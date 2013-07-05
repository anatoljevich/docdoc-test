class Upload < ActiveRecord::Base
  attr_accessible :file
  validates :data, :presence => true

  def file=(f)
    logger.error f
    self.data = f.read
  end

  def synchronize
    phones_id = []
    CSV.parse(self.data, {:col_sep => "\t"}) do |row|
      number, name, updated_at = row.split("\t").flatten
      begin
        phone = Phone.find_by_number(number)
        if phone
          phones_id << phone.id
          if phone.name == name && phone.updated_at < Time.parse(updated_at)
            phone.update_attribute(:name, name)
          end
        else
          Phone.create({:number => number, :name => name, :synch_version => self.id})
        end
      rescue ActiveRecord::StatementInvalid, ArgumentError => e # skip record if can't import
        logger.error e
      end
    end
    Phone.where(:id => phones_id).update_all(:synch_version => self.id) unless phones_id.empty?
    Phone.delete_all "synch_version < #{self.id}"
  rescue CSV::MalformedCSVError => e
    logger.error e
    false
  end

end
