module FacebookHelper
  require "net/http"
  
  def fb_auth_login_url
    "https://www.facebook.com/dialog/oauth?" + 
    "client_id=" + ApplicationController::FB_APP_ID + 
    "&redirect_uri=" + ApplicationController::ROOT_URL + "/fb_callback/" + 
    "&scope=ads_read"
  end
  
  def get_fb_tokens(code)
    request_params = {}
    
    request_params['code'] = code
    request_params['client_id'] = ApplicationController::FB_APP_ID
    request_params['client_secret'] = ApplicationController::FB_APP_SECRET
    request_params['redirect_uri'] = ApplicationController::ROOT_URL + '/fb_callback/'
    
    url = URI.parse('https://graph.facebook.com')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    # Use verify_peer in prod 
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER 
    
    # Make request for tokens 
    request = Net::HTTP::Post.new('/oauth/access_token')
    request.set_form_data(request_params)
    response = http.request(request)
    
    CGI::parse(response.body)
  end
    
end
