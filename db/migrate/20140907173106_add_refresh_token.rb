class AddRefreshToken < ActiveRecord::Migration
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :fb_access_token, :string
    add_column :users, :serialized_ga_views, :text
  end
end
