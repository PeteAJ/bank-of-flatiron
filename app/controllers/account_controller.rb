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
  #binding.pry
  # is user logged_in?
  if logged_in?
    # find account
  account = Account.find_by_id(params[:id])
    # is the owner of the account the current client?
    if account.client == current_client
        #account.transactions.create
        transaction = account.create_transaction(params[:transaction_type], params[:transaction_amount].to_i)

        #add transaction to account.balance
        #update and save balance
        if transaction.description == 'withdrawl'
          new_balance = account.balance - params[:transaction_amount].to_i
        elsif transaction.description == 'deposit'
          new_balance = account.balance + params[:transaction_amount].to_i
        end


        if account.overdraft_protection && new_balance.between?(-200,0)
              new_balance = new_balance - 25
            end

            account.update(balance: new_balance)


      #if account.overdraft_protection && new_balance.between?(-200,0)
      #  new_balance = new_balance - 25
      #  account.update(balance: new_balance)
      #elsif account.overdraft_protection && new_balance < -200
        #dont save transaction
      #elsif acccount.overdraft_protection && new_balance > 0
      #  account.update(balance: new_balance)
      #end



        #if no overdraft_protection, withdrawl ok to zero

        #if overdraft_protection, withdrawl ok up to -200 after withdrawl

        #if overdraft_protection, withdrawl than leaves balance below zero, charge 25


          redirect to "/accounts/#{account.id}"
    else
        # redirect to accounts show page
        redirect to '/accounts/show'
    end
  end
end

post '/accounts/:id/transfer' do

  if logged_in?
  account = Account.find_by_id(params[:id])

    

          redirect to "/accounts/#{account.id}"
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
