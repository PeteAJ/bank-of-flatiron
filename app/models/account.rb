class Account < ActiveRecord::Base
  belongs_to :client
  has_many :transactions
  #validates :dollar_amount, :numericality => { :greater_than => 0 }

  


end
