module ApplicationHelper
  def full_title(page_title)
    base_title = "CloudFiles"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def signed_in?
    session[:current_user_id]
  end
end
