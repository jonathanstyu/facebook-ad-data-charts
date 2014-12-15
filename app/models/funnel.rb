class Funnel < ActiveRecord::Base
  has_many :steps
  belongs_to :user
  
  accepts_nested_attributes_for :steps
  
  def landing_page
    self.steps.first
  end
end
