class CreateFunnels < ActiveRecord::Migration
  def change
    create_table :funnels do |t|
      t.string :name
      t.string :goal
      t.integer :user_id
      t.timestamps
    end
  end
end
