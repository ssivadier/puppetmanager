class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Authenticate via CAS
  before_action :authenticate!
  def authenticate!
    if session[:user_id].blank?
      redirect_to "/auth/cas"
    end
  end
end
