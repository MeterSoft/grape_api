class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :role
    end

    add_index :users, :id, :unique => true
  end
end
