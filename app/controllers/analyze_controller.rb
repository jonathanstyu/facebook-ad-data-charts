class AnalyzeController < ApplicationController
  before_filter :authenticate_user
  before_filter :confirm_account_id
    
  def analyze
    @query = Query.new(@current_user.access_token, params)
    
    # This is for loading dummy data for testing purposes
    a = File.read('./config/rows.csv').gsub(/(\,)(\S)/, "\\1 \\2")
    @query.rows = YAML::load(a)
    
    unless @query.insufficient_params
      # @query.execute_data_request
      
      if @query.error_message
        flash[:error] = @query.error_message
      end
      
      # File.open(File.join('./config', 'rows.csv'), 'w') do |f|
      #   f.puts @query.rows.to_s
      # end
    end
    
  end
  
end
