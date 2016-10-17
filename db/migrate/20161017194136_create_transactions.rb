class CreateTransactions < ActiveRecord::Migration
  def change
      create_table :transactions do |t|
                t.integer :client_id
                t.integer :account_id

        t.timestamps null: false
      end
  end
end
