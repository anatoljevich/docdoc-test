module ApplicationHelper

  def error_messages_for(record)
    render :partial => 'shared/error_messages', :locals => {:record => record}
  end

end
