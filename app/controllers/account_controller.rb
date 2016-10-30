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
  @account = Account.find_by_id(params[:id])
  if @account.client == current_client
  erb :'/accounts/show'
  else
  redirect to '/accounts'
  end
  end
end

get 'accounts/:id/edit' do #loads edit form
  if logged_in?
  @account = Account.find_by_id(params[:id])
  erb :'/accounts/edit'
  else
  redirect to '/accounts'
  end
end


# user can make a deposit or withdawal from their account/:id page
# user submits form and this will update the account with a new transaction
post '/accounts/:id/new_transaction' do
  # is user logged_in?
  if logged_in?
    # find account
  @account = Account.find_by_id(params[:id])
    # is the owner of the account the current client?
    if @account.client == current_client
        #account.transactions.create
        @account.create_transaction(params[:transaction_type], params[:transaction_amount].to_i)

        #add transaction to account.balance
        #update and save balance

        @account.update(:balance => @account.balance + params[:transaction_amount].to_i)
        @account.save


        #if transaction is withdrawl, subtract amount otherwise add transaction amount to balance
        #  if @account.create_transaction(params[:transaction_type], params[:transaction_amount].to_i)


          redirect to "/accounts/#{@account.id}"
    else
        # redirect to accounts show page
        redirect to '/accounts/show'
    end
  end
end


post 'accounts/:id/acct_transfer' do
  # is user logged_in?
  if logged_in?
    # find account
  @account = Account.find_by_id(params[:id])
    # is the owner of the account the current client?
  if @account.client == current_client
      # account.transactions.create
  @account.transactions.create
  else
      # redirect to accounts show page
  redirect to '/accounts/show'
  end
  end
end


patch '/accounts/:id' do #updates accounts
  @account = Account.find_by_id(params[:id])
  @account.name = params[:name]
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
