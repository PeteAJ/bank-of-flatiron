class Transaction < ActiveRecord::Base
  belongs_to  :client
  belongs_to :account

end
