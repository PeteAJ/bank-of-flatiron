class Client < ActiveRecord::Base
 has_many  :accounts
 has_secure_password
 validates_presence_of :name, :nickname, :email, :password

 def slug
  name.downcase.gsub(" ","-")
end

  def self.find_by_slug(slug)
    Client.all.find{|client| client.slug == slug}
  end

end