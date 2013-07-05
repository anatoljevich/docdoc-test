class PhonesController < ApplicationController
  
  def index
    @phones = Phone.order('id DESC')
    respond_to do |format|
      format.html
      format.text{send_data @phones.to_csv}
    end
  end

  def create
    @phone = Phone.new params[:phone]
    flash.now[:notice] = if @phone.save
      "Record #{@phone.number} created."
    end
    respond_to do |format|
      format.html {flash.keep; redirect_to phones_path}
      format.js
    end
  end

  def destroy
    @phone = Phone.find_by_id params[:id]
    flash.now[:notice] = if @phone
      @phone.destroy
      "Record was deleted."
    else
      "Unable to delete record"
    end
    respond_to do |format|
      format.html {flash.keep; redirect_to phones_path}
      format.js
    end
  end

  def update
    @phone = Phone.find_by_id params[:id]
    if @phone
      @phone.update_attributes params[:phone]
    end
    respond_to do |format|
      format.html {redirect_to phones_path}
      format.json {respond_with_bip(@phone)}
    end
  end

  def upload
    @upload = Upload.new params[:upload]
    if @upload.save
      @upload.synchronize
    else
      flash[:notice] = 'Unable to upload data'
    end
    redirect_to phones_path
  end
  
end
