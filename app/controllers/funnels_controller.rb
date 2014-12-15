class FunnelsController < ApplicationController
  before_action :set_funnel, only: [:show, :edit, :update, :destroy]
  
  def index
    @funnels = @current_user.funnels
    @account_id = params[:account_id]
  end
  
  def new
    @account_id = params[:account_id]
    @funnel = Funnel.new
  end
  
  def edit
  end
  
  def create
    @funnel = Funnel.new(user_params)

    respond_to do |format|
      if @funnel.save
        format.html { redirect_to root_path, notice: 'Funnel was successfully created.' }
        format.json { render :show, status: :created, location: @funnel }
      else
        format.html { render :new }
        format.json { render json: @funnel.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @query = Query.new(@current_user.access_token, params)
    unless @query.insufficient_params
      @query.execute_data_request
      if @query.error_message
        flash[:error] = @query.error_message
      end
    end    
  end
  
  def events
    # @query = EventsQuery.new(@current_user.access_token, params)
    # @query.execute_data_request
    #
    # render json: @query.rows
    
    fake_data = [["saw product", 2], ["click on product", 10], ["add to cart", 13], ["purchase", 5]]
    render json: fake_data
  end
  
private
  # Use callbacks to share common setup or constraints between actions.
  def set_funnel
    @funnel = Funnel.includes(:steps).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def funnel_params
    params.require(:funnel).permit(:email, :password)
  end
  
end
