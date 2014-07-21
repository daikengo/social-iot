class CreateGroupRelations < ActiveRecord::Migration
  def change
    create_table :group_relations do |t|
      t.integer :channel_id_one
      t.integer :channel_id_two
      t.integer :ttl
      t.integer :group_id

      t.timestamps
    end
  end
end
