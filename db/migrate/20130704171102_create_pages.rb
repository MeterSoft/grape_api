class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.datetime :published_on
      t.integer :user_id

      t.timestamps
    end

    add_index :pages, :id, :unique => true
  end
end
