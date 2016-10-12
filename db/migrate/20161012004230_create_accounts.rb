class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |a|
              a.string :name
              a.integer :balance
              a.boolean :overdraft_protection, :default => false

      a.timestamps null: false
    end
  end
end
