
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
  @transaction.name = params[:name]
  @transaction.balance = params[:balance]
  @transaction.overdraft_protection = params[:overdraft_protection]
  @transaction.save
  redirect to '/transactions/#{@transaction.id}'
end

  post '/transactions' do #creates an transaction.t
  if params[:initial_deposit].to_i < 50
    redirect to '/transactions'
  else
    @transaction = transaction.create(name: params[:name], :overdraft_protection => params[:overdraft_protection])
    @transaction.balance = params[:initial_deposit]
    @transaction.client_id = current_client.id
    @transaction.save
    redirect to "/transactions/#{@transaction.id}"
    end
  end

delete '/transactions/:id/delete' do #deletes transaction - exclude?
end




end
