class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_user_logged!

  private

  def check_user_logged!
    if session[:current_user_id] and controller_name == 'sessions' and action_name != 'destroy'
      flash[:alert] = "Ya se encuentra logeado"
      return redirect_to root_url 
    end
    if controller_name == 'pages' and not signed_in?
      flash[:alert] = "Debe logearse"
      return redirect_to users_sign_in_path 
    end
  end
end
