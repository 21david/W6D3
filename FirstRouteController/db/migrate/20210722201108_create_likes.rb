class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id, null: false
      t.integer :comment_id
      t.integer :artwork_id
    end
      add_index :likes, :user_id
      add_index :likes, :comment_id
      add_index :likes, :artwork_id
      add_index :likes, [:user_id,:comment_id], unique: true
      add_index :likes, [:user_id,:artwork_id], unique: true
  end
end
