class FBAdQuery
  require "net/http"
  attr_accessor :error_message, :insufficient_params, :data
  
  def initialize(access_token, account, params={})
    super()
    
    @insufficient_params = true
    
    @access_token = access_token
    @account = account
    @request_params = {}
    
    build_params(params)
  end
  
  def build_params(params)
    @request_params['access_token'] = @access_token
    @request_params['date_preset'] = params['date_preset']
    @request_params['data_columns'] = "['account_id'," + params['data_columns'].to_s + "]"
    
  end
  
  def request
    url = URI.parse("https://graph.facebook.com/v2.2/act_#{@account.ad_account_id}/reportstats")
    url.query = URI.encode_www_form(@request_params)
    
    response = Net::HTTP.get_response(url)
    
    @data = JSON.parse(response.body)
  end
    
end