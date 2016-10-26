require './config/environment'

class ClientsController < ApplicationController

#get '/clients/new' do #loads new client form
#end

get '/clients' do #loads index

end

get '/clients/:id' do #show 1 client
  @client = Client.find_by_id(params[:id])
  erb :'/clients/show'
end

get '/clients/:id/edit' do #edit client form
  @client = Client.find(params[:id])
  erb :'/clients/edit'
end

patch '/clients/:id' do #updates clients
  @client = Client.find_by_id(params[:id])
  @client.email = params[:email]
  @client.save
  redirect to "/clients/#{@client.id}"
end

post '/clients/:id' do
  @account.balance = Account.find_by_id(params[:balance])
  deposit = params[:deposit_amount].to_i
  @account.balance += deposit
  @account.balance.save
  redirect to "/clients/#{@client.id}"
end



#post '/clients' do #creates a client
#end

end
