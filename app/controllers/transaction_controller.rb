
require './config/environment'

class TransactionsController < ApplicationController

get '/transactions/new' do #load new acount form
  erb :'/transactions/new'
end

get '/transactions' do #loads index
  if logged_in?
  @transactions = Transaction.all
  erb :'/transactions/index'
  else
  erb :index
  end
  end

get '/transactionss/:id' do #loads show 1 Account
  @transaction = Transaction.find_by_id(params[:id])
  erb :'/transactions/show'
end

get 'transactions/:id/edit' do #loads edit form
  if !logged_in?
    redirect "/login"
  else
    account = current_user.transactions.find(params[:id])
  erb ':/transactions/edit'
end
end

patch '/transactions/:id' do #updates accounts
  @account = Account.find_by_id(params[:id])
  @account.name = params[:name]
  @account.balance = params[:balance]
  @account.overdraft_protection = params[:overdraft_protection]
  @account.save
  redirect to '/accounts/#{@account.id}'
end

  post '/transactions' do #creates an Account.t
  if params[:initial_deposit].to_i < 50
    redirect to '/accounts'
  else
    @account = Account.create(name: params[:name], :overdraft_protection => params[:overdraft_protection])
    @account.balance = params[:initial_deposit]
    @account.client_id = current_client.id
    @account.save
    redirect to "/accounts/#{@account.id}"
    end
  end

delete '/transactions/:id/delete' do #deletes account - exclude?
end




end
