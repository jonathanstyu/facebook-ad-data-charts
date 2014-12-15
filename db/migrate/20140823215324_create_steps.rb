class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :url
      t.string :title
      t.text :description
      t.text :meta
      t.text :internal_links
      t.text :external_links
      t.integer :funnel_id
      t.timestamps
    end
  end
end
