class CreateFbAccounts < ActiveRecord::Migration
  def change
    create_table :fb_accounts do |t|
      t.string :ad_account_id
      t.integer :user_id
      t.timestamps
    end
  end
end
