class Client < ActiveRecord::Base

 has_many  :accounts
 has_secure_password
 attr_accessor :password

 validates :password, presence: true, length: { in: 3..20 }, confirmation: true


end
