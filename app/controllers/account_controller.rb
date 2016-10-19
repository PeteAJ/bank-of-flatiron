require './config/environment'

class AccountsController < ApplicationController

get '/accounts/new' do #load new acount form
  erb :'/accounts/new'
end

get '/accounts' do #loads index
  if logged_in?
  @accounts = Account.all
  erb :'/accounts/index'
  else
  erb :index
  end
  end

get '/accounts/:id' do #loads show 1 Account
  @account = Account.find_by_id(params[:id])
  erb :'/accounts/show'
end

get 'accounts/:id/edit' do #loads edit form
  if !logged_in?
    redirect "/login"
  else
    account = current_user.accounts.find(params[:id])
  erb :'/accounts/edit'
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

post '/accounts/transfer' do
end


end
