class EventsQuery
  attr_accessor :parameters, :rows, :error_message, :dimension
  
  require 'json'
  require 'google/api_client'
  require 'date'
  
  def initialize(access_token, params={})
    super()
    
    @access_token = access_token
    @dimension = params['dimensions']
    @account_id = params['account_id']
    set_up_api_client
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
    data_request = @api_method.data.ga.get
    
    @response = @client.execute(:api_method => data_request, :parameters => {
      ids: "ga:#{@account_id}",
      dimensions: "ga:#{@dimension}",
      metrics: 'ga:users',
      sort: '-ga:users',
      'start-date' => 14.days.ago.strftime("%Y-%m-%d"),
      'end-date' => Date.today.strftime("%Y-%m-%d"),
      'max-results' => '50'
    })
    
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