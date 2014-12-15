class Query
  attr_accessor :parameters, :rows, :insufficient_params, :error_message
  
  require 'json'
  require 'google/api_client'
  require 'date'
  
  def initialize(access_token, params={})
    super()
    
    @insufficient_params = true
    
    @access_token = access_token
    parse_params(params)
    set_up_api_client

  end
  
  def parse_params(params)
    @parameters = {}
    
    # Capture essential params for a complete query pull
    if params[:start_date] && params[:end_date] && params[:account_id] && params[:metrics]
      @parameters['start-date'] = Date.parse(params[:start_date]).strftime("%Y-%m-%d")
      @parameters['end-date'] = Date.parse(params[:end_date]).strftime("%Y-%m-%d")
      
      @parameters['ids'] = "ga:#{params[:account_id]}"
      
      @parameters['metrics'] = params[:metrics]
      
      @insufficient_params = false
    end
    
    # Unessential params for further analysis 
    @parameters['dimensions'] = params[:dimensions] unless params[:dimensions].blank?
    @parameters['segment'] = params[:segment] unless params[:segment].blank?
    @parameters['sort'] = params[:sort] unless params[:sort].blank?    
  end
  
  def set_up_api_client
    @client = Google::APIClient.new(
      application_name: 'Analytics Tool',
      application_version: '1.0'
    )

    @client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience: 'https://accounts.google.com/o/oauth2/token',
      scope: 'https://www.googleapis.com/auth/analytics.readonly',
      access_token: @access_token
    )

    @api_method = @client.discovered_api('analytics', 'v3')
  end
    
  def execute_data_request
    return 'insufficient params' if @insufficient_params 
    
    data_request = @api_method.data.ga.get
    
    @response = @client.execute(:api_method => data_request, :parameters => @parameters)
    
    if @response.error?
      @error_message = @response.error_message
    else
      @rows = @response.data.rows.reverse
    end
    
  end
  
  def metric(dimension)

    if @insufficient_params || @error_message
      'Error'
    else
      @rows.each do |row|
        return row[1] if row[0].chomp('/') == dimension.chomp('/')
      end
    end    
  end
  
end