class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  # Authenticate via CAS if not in dev env
  unless Rails.env.development?
    before_action :authenticate!
  end

  def authenticate!
    if session[:user_id].blank?
      case request.format
      when Mime::XML, Mime::JSON
        restrict_access
      else
        redirect_to "/auth/cas"
      end
    end
  end

  def restrict_access
    unless User.exists?(auth_token: params[:authtoken])
      authenticate_or_request_with_http_token do |token, options|
        User.exists?(auth_token: token)
      end
    end
  end

  def set_locale
    if cookies[:educator_locale] && I18n.available_locales.include?(cookies[:educator_locale].to_sym)
      l = cookies[:educator_locale].to_sym
    else
      l = I18n.default_locale
      cookies.permanent[:educator_locale] = l
    end
    I18n.locale = l
  end

end
