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
  @transactions = current_client.transactions
    if @account && @account.client == current_client
      erb :'/accounts/show'
    else
      redirect to '/accounts'
    end
  end
end


get '/accounts/:id/edit' do #loads edit form
  @account = Account.find_by_id(params[:id])
  erb :'/accounts/edit'
end


patch '/accounts/:id' do #updates clients - edit action
  @account = Account.find_by_id(params[:id])
  @account.name = params[:name]
  @account.save
  redirect to "/accounts/#{@account.id}"
end



# user can make a deposit or withdawal from their account/:id page
# user submits form and this will update the account with a new transaction
post '/accounts/:id/new_transaction' do
  if logged_in?
    account = Account.find_by_id(params[:id])
    if account.client == current_client
      #transaction = account.transactions.create(description: params[:transaction_type], amount: params[:transaction_amount])
        transaction = account.create_transaction(params[:transaction_type], params[:transaction_amount].to_i)
        if transaction.description == 'withdrawl'
          new_balance = account.balance - params[:transaction_amount].to_i
          if account.overdraft_protection
             if new_balance.between?(-200,0)
               new_balance = new_balance - 25
             elsif new_balance < -200
              flash[:notice] = "transaction rejected"
              redirect to "accounts/#{account.id}"
             end
          end
          validate_overdraft_transaction(account, new_balance, account.id)
        elsif transaction.description == 'deposit'
          new_balance = account.balance + params[:transaction_amount].to_i
        end
        account.update(balance: new_balance)

        redirect to "/accounts/#{account.id}"
    else
        redirect to "/accounts/#{account.id}"
    end
  end
end



post '/accounts/transfer' do

  if logged_in?
    origin_account = current_client.accounts.find_by(name: params[:account_from_name])
    destination_account = current_client.accounts.find_by(name: params[:account_to_name])

    if origin_account && destination_account && origin_account.name != destination_account.name
      # transfer
      new_balance = origin_account.balance - params[:transaction_amount].to_i
      origin_account.balance -= params[:transaction_amount].to_i
      destination_account.balance += params[:transaction_amount].to_i


      validate_overdraft_transaction(origin_account, new_balance)
      #else
        #flash[:notice] = "Transaction unsuccessful"


      #if its valid?
      origin_account.save
      destination_account.save
      flash[:notice] = "*transaction successful*"



    else
      #binding.pry
      flash[:notice] = "*transaction not completed. please enter valid account names.*"
    end

    redirect to '/accounts'
  else
    redirect to '/sessions/login'
  end

end


post '/accounts/transfer/outside' do

  if logged_in?
    origin_account = current_client.accounts.find_by(name: params[:account_from_name])


    client = Client.find_by_email(email: params[:account_to_email])
    destination_account = client && client.accounts.find_by(name: params[:account_to_name])

    if origin_account && destination_account
      # transfer
      new_balance = origin_account.balance - params[:transaction_amount].to_i
      origin_account.balance -= params[:transaction_amount].to_i
      destination_account.balance += params[:transaction_amount].to_i

      validate_overdraft_transaction(origin_account, new_balance)
      #else
        #flash[:notice] = "Transaction unsuccessful"


      #if its valid?
      origin_account.save
      destination_account.save
      flash[:notice] = "*transaction successful*"



    else
      #binding.pry
      flash[:notice] = "*transaction not completed. please enter valid account name and email for the user you would like to transfer money to.*"
    end

    redirect to '/accounts'
  else
    redirect to '/sessions/login'
  end

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
