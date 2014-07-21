class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :tag1
      t.string :tag2
      t.string :tag3

      t.timestamps
    end
  end
end
