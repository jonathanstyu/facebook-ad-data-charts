class ViewsQuery
  attr_accessor :start_date, :end_date, :rows
  
  require 'json'
  require 'google/api_client'
  require 'date'
  
  def initialize(access_token)
    super()
    
    @access_token = access_token
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
  
  def get_ga_views
    views = @api_method.management.profiles.list
    
    @response = @client.execute(:api_method => views, :parameters => {
      'accountId'        => '~all',
      'webPropertyId'    => '~all'
    })
    
    parse_ga_views(@response)
  end
  
  def parse_ga_views(response)
    views = []
    
    response.data.items.each do |item|
      views << item.to_hash
    end
    
    views
  end
  
end