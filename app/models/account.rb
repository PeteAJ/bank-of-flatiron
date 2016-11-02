class Account < ActiveRecord::Base
  belongs_to :client
  has_many :transactions
  #validates :dollar_amount, :numericality => { :greater_than => 0 }

  def create_transaction(type,amount)
    self.transactions.create(description: type, amount: amount)
  end
end
