class SessionsController < ApplicationController
  # Skip authenticate! filter ; if we don't do that,
  # the app requires to be authenticated BEFORE accessing
  # actions that lead to authentication, which leads to a
  # redirect loop...
  skip_before_action :authenticate!

  def create
    auth = request.env["omniauth.auth"]
    if user = User.where("lower(uid) = ?", auth["uid"].downcase).first
      session[:user_id] = user.id
      session[:user_uid] = user.uid
      redirect_to root_url, :notice => "Signed in!"
	  logger.info "[#{session[:user_uid]}] User signed in"
    else
      redirect_to welcome_url, :alert => "Login failed ! No user with uid=#{auth["uid"]}"
	  logger.error "[#{session[:user_uid]}] Login failed"
    end
  end

  def destroy
    session[:user_id] = nil
    cas_logout_url = "https://authentification-cerbere.application.i2/cas/logout?gateway=1&service=#{root_url}"
    #cas_logout_url = OmniAuth.config.full_host
    #                     .merge("/logout?gateway=1&service=#{welcome_url}")
    #                     .to_s
    redirect_to cas_logout_url
  end
end
