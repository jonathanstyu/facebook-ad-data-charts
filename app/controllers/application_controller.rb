class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_current_user
  
  include GoogleHelper
  include FacebookHelper
  include SessionsHelper
    
  def current_user
    @current_user ||= User.where(session_token: session[:token]).take
  end
  
  def find_current_user
    return nil if session[:token].nil?
    current_user
  end
  
  private
  
  def authenticate_user
    if @current_user == nil
      
      redirect_to :root, status: 401
    end
  end
  
  def confirm_account_id
    if params[:account_id] == nil
      flash[:error] = "Account ID required for this action"
      redirect_to :root
    end
  end
  
end
