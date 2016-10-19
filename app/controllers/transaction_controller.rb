
class TransactionsController < ApplicationController


get '/transactions/new' do #load new transaction form
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

get '/transactionss/:id' do #loads show 1 transaction
  @transaction = Transaction.find_by_id(params[:id])
  erb :'/transactions/show'
end



patch '/transactions/:id' do #updates transactions
  @transaction = transaction.find_by_id(params[:id])
  @transaction.date = params[:date]
  @transaction.amount = params[:amount]
  @transaction.description = params[:description]
  @transaction.account_balance = params[:account_balance]
  @transaction.save
  redirect to '/transactions/#{@transaction.id}'
end

  post '/transactions' do #creates an transaction
  if params[:withdrawl].to_i > :account_balance && !account.overdraft_protection = nil
    "You can only withdraw to 0 on your account"
    @transaction = transaction.create(amount: params[:amount], :description => params[:description])
    @transaction.account_balance = params[:account_balance]
    @transaction.account_id = account.id
    @transaction.save
    redirect to "/transactions/#{@transactions.id}"
    else
  if params[:withdrawl].to_i > :account_balance && account.overdraft_protection = nil
    "You have overdraft protection but will be charged if your account goes below -$200"
    @transaction = transaction.create(amount: params[:amount], :description => params[:description])
    @transaction.account_balance = params[:account_balance]
    @transaction.account_id = account.id
    @transaction.save
    redirect to "/transactions/#{@transactions.id}"
  else
    @transaction = transaction.create(amount: params[:amount], :description => params[:description])
    @transaction.account_balance = params[:account_balance]
    @transaction.account_id = account.id
    @transaction.save
    redirect to "/transactions/#{@transaction.id}"
    end
  end
  end






end
