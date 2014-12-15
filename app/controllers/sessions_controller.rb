class SessionsController < ApplicationController
  before_filter :check_user_access_token, only: [:gaviews_query]
    
  def create
    user = User.find_by_email(params[:email])
    if user && user.verify_password(params[:password])
      session[:token] = user.generate_session_token!
      redirect_to root_path
    else
      flash[:error] = "Password Failed"
      redirect_to :back
    end
  end
  
  def destroy
    @current_user.session_token = nil 
    @current_user.save!
    session[:token] = nil 
    redirect_to root_path
  end
  
  # Beginning URL of FB/Google Logins
  
  def fbauthorize
    redirect_to fb_auth_login_url.to_s
  end
  
  def gauthorize
    redirect_to ga_oauth_login_url.to_s
  end
  
  # Second step. Callback handlers from FB and Google
  
  def google_callback
    tokens = get_tokens(params["code"])

    @current_user.access_token = tokens["access_token"]
    @current_user.save!
    
    flash[:notice] = "Authorized"
    
    redirect_to :root
  end
  
  def fb_callback
    tokens = get_fb_tokens(params['code'])
    
    @current_user.fb_access_token = tokens['access_token'].first
    @current_user.save!
    
    flash[:notice] = "Facebook Authorized"
    
    redirect_to :root
  end
  
  def fb_tokenresponse
    puts params
    flash[:notice] = "Facebook Authorized"
    
    redirect_to :root
  end
    
  private 
  
  def check_user_access_token
    unless @current_user.access_token
      flash[:error] = "Please Grant Analytics Authorization"
      redirect_to :back
    end
  end
    
end
