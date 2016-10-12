class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |c|
              c.string :name
              c.string :email
              c.string :password_digest

      c.timestamps null: false
    end
  end
end
