module GoogleHelper
  
  def ga_oauth_login_url
    client = OAuth2::Client.new(
      ApplicationController::GOOGLE_CLIENT_ID, 
      ApplicationController::GOOGLE_CLIENT_SECRET,
      authorize_url: 'https://accounts.google.com/o/oauth2/auth',
      token_url: 'https://accounts.google.com/o/oauth2/token'
    )
    
    client.auth_code.authorize_url({
      scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/analytics.readonly',
      redirect_uri: ApplicationController::ROOT_URL + '/googlecallback',
      access_type: 'offline',
      response_type: 'code'
    })
  end
  
  def get_tokens(code)
    request_params = {}
    
    request_params['code'] = code
    request_params['client_id'] = ApplicationController::GOOGLE_CLIENT_ID
    request_params['client_secret'] = ApplicationController::GOOGLE_CLIENT_SECRET
    request_params['redirect_uri'] = ApplicationController::ROOT_URL + '/googlecallback'
    request_params['grant_type'] = 'authorization_code'
    
    url = URI.parse('https://accounts.google.com')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    # Use verify_peer in prod 
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER 
    
    # Make request for tokens 
    request = Net::HTTP::Post.new('/o/oauth2/token')
    request.set_form_data(request_params)
    response = http.request(request)
    
    

    JSON.parse(response.body)
    
  end
  
  def call_api(path, access_token)
    #Initialize HTTP library
    
    url = URI.parse('https://www.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production
    
    #Make request 
    
    request = Net::HTTP::Get.new(path)
    request['Authorization'] = 'Bearer' + access_token
    response = http.request(request)
    
    JSON.parse(response.body)
  end
  
  def valid_token?(access_token)
    path = '/oauth2/v1/tokeninfo'

    # Initialize HTTP library
    url = URI.parse('https://www.googleapis.com')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production

    # Make request to API
    request = Net::HTTP::Get.new(path)
    request['Authorization'] = 'Bearer ' + access_token
    response = http.request(request)

    result = JSON.parse(response.body)

    result['error'].nil? || result['error'] != 'invalid_token'
  end
    
end