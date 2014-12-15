class FbAccount < ActiveRecord::Base
  belongs_to :user
  
  validates :user, presence: true
  validates :ad_account_id, presence: true
  validates_uniqueness_of :ad_account_id, scope: :user_id
  
end
