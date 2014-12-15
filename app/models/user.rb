class User < ActiveRecord::Base
  has_many :funnels
  has_many :fb_accounts
  serialize :serialized_ga_views, Array
  accepts_nested_attributes_for :fb_accounts
  
  include BCrypt
  
  def password=(password)
    self.password_hash = Password.create(password)
  end
  
  def verify_password(password)
    Password.new(self.password_hash) == password
  end
  
  def generate_session_token!
    self.session_token = SecureRandom.urlsafe_base64(35)
    self.save!
    self.session_token 
  end
    
end
