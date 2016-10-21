require './config/environment'

class AccountsController < ApplicationController

get '/accounts/new' do #load new account form
  erb :'/accounts/new'
end

get '/accounts' do #loads index
  if logged_in?
  @accounts = current_client.accounts
  erb :'/accounts/index'
  else
  erb :index
  end
end

get '/accounts/:id' do #loads show 1 Account
  if logged_in?
  @@account = Account.find_by_id(params[:id])
  if @@account.client == current_client
  erb :'/accounts/show'
  else
  redirect to '/accounts'
  end
  end
end

get 'accounts/:id/edit' do #loads edit form
  @account = Account.find_by_id(params[:id])
  erb :'/accounts/edit'
end

# user can make a deposit or withdawal from their account/:id page
# user submits form and this will update the account with a new transaction
post 'accounts/:id/new_transaction' do
  # is user logged_in?
  if logged_in?
    # find account
  @account = Account.find_by_id(params[:id])
    # is the owner of the account the current client?
  if @account.client == current_client
      # account.transactions.create
  @account.transactions.create
      # redirect to accounts show page
  redirect to '/accounts/show'
  end
  end
end



patch '/accounts/:id' do #updates accounts
  @account = Account.find_by_id(params[:id])
  @account.name = params[:name]
  @account.balance = params[:balance]
  @account.overdraft_protection = params[:overdraft_protection]
  @account.save
  redirect to "/accounts/#{@account.id}"
end

post '/accounts' do #creates an Account
  if params[:initial_deposit].to_i < 50
  redirect to "/accounts"
  else
  @account = Account.create(name: params[:name], :overdraft_protection => params[:overdraft_protection])
  @account.balance = params[:initial_deposit]
  @account.client_id = current_client.id
  @account.save
  redirect to "/accounts/#{@account.id}"
  end
end

delete '/accounts/:id/delete' do #deletes account - exclude?
  @account = Account.find_by_id(params[:id])
  @account.delete
  redirect to "/accounts"
end





end
