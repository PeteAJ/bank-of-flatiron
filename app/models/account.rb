class Account < ActiveRecord::Base
  belongs_to :client
  has_many :transactions

  def create_transaction(type,amount)
    self.transactions.create(description: type, amount: amount)
  end
end
