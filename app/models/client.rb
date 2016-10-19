class Client < ActiveRecord::Base
  has_many  :accounts
  has_many :transactions, through: :accounts
  has_secure_password
end
