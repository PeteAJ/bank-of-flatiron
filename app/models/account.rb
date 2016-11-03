class Account < ActiveRecord::Base
  belongs_to :client
  has_many :transactions
  #validates :dollar_amount, :numericality => { :greater_than => 0 }

  def create_transaction(type,amount)
    self.transactions.create(description: type, amount: amount)
  end

  def create_transfer(from,to,amount)
    self.accounts.create(name: from, name: to, amount: amount)
  end

  def valid_transaction?(name, amount)
    self.transactions.create(name: name, amount: amount)
      #if no overdraft_protection, withdrawl ok to zero
      new_balance = account.balance - params[:transaction_amount].to_i
      if !account.overdraft_protection && new_balance < 0
        flash[:notice] = "*rejected - insufficient funds!*"
      end
        redirect to "/accounts/#{account.id}"
  end
end
