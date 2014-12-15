class FbAccountsController < ApplicationController
  before_action :set_fb_account, only: [:show]
  
  def new
    @fb_account = FbAccount.new
  end
  
  def create
    @fb_account = @current_user.fb_accounts.create(fb_account_params)
    
    if @fb_account.save
      flash[:success] = "Facebook Account #{@fb_account.ad_account_id} Created"
      redirect_to :back
    else
      flash[:error] = @fb_account.errors.full_messages.first
      redirect_to :back 
    end
  end
  
  def show
  end
  
  def query
    @fb_account = FbAccount.find(params[:fb_account_id])
    
    # This code segment is for hard coding the data_columns in the request for future custom queries
    query_col = {}
    query_col["data_columns"] = '"clicks", "cpm","cpp","spend","ctr","cpc","cost_per_unique_click","frequency","impressions","actions_1d_click","unique_actions_1d_click_by_convs"'
    query_col["date_preset"] = params["date_preset"]

    @fb_account_query = FBAdQuery.new(@current_user.fb_access_token, @fb_account, query_col)
    
    # Comment this out to use dummy data
    @fb_account_query.request()
    render json: @fb_account_query.data

    # Uncomment to use dummy date
    # a = File.read('./config/reportstats.json')
    # render json: JSON.parse(a)
  end
  
  private
  
  def set_fb_account
    @fb_account = FbAccount.find(params[:id])
  end
  
  def fb_account_params
    params.require(:fb_account).permit(:ad_account_id)
  end
  
  
end
