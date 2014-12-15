class StaticPagesController < ApplicationController
  
  def home
    if @current_user
      @funnels = @current_user.funnels
    end
  end
  
end
