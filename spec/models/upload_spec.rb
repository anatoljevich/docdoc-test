require 'spec_helper'

describe Upload do

    it "should not be valid if data is empty" do
      upload = FactoryGirl.build(:upload, :data => nil)
      upload.valid?.should be_false
    end

  context '#synchronize' do

    it "should add new phone" do
      upload = FactoryGirl.create(:upload, :data => "+888 000 2122 45\tJohn Smith")
      expect {
        upload.synchronize
      }.to change { Phone.count }.by(1)
    end

    it "should remove old phone" do
        old_phone = FactoryGirl.create(:phone, :name => "Matt Jason", :number => "550 612 083 48")
        upload = FactoryGirl.create(:upload, :data => "+888 000 2122 45\tJohn Smith")
        upload.synchronize
        Phone.exists?(old_phone.id).should be_false
    end

    it "should not remove old phone if its synch_version more than upload.id" do
        upload = FactoryGirl.create(:upload, :data => "+888 000 2122 45\tJohn Smith")
        old_phone = FactoryGirl.create(:phone, :name => "Matt Jason", :number => "550 612 083 48", :synch_version => upload.id + 1)
        upload.synchronize
        Phone.exists?(old_phone.id).should be_true
    end

    it "should update name if number found" do
        old_phone = FactoryGirl.create(:phone, :name => "Matt Jason", :number => "550 612 083 48")
        upload = FactoryGirl.create(:upload, :data => "550 612 083 48\tJohn Smith\t#{Time.now + 1}")
        upload.synchronize
        Phone.find_by_number("550 612 083 48").name.should  == "John Smith"
    end
  end
end