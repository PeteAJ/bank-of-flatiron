class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
              t.string :name
              t.integer :balance
              t.boolean :overdraft_protection, :default => false

      t.timestamps null: false
    end
  end
end
