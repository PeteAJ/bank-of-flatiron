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

  def valid_transaction()

    if !account.overdraft_protection && new_balance < 0
              flash[:notice] = "Withdrawl rejected - insufficient funds!"
             redirect to "/accounts/#{account.id}"
            end


  if !origin_account.overdraft_protection && new_balance < 0
          flash[:notice] = "Withdrawl rejected - insufficient funds!"
          redirect to "/accounts"
        end


  end



end
