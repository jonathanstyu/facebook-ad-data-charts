class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :session_token
      t.string :uid
      t.string :access_token
      t.string :expires
      t.timestamps
    end
  end
end
