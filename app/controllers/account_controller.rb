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
  if @account && @account.client == current_client
  erb :'/accounts/show'
  else
  redirect to '/accounts'
  end
  end
end

get 'accounts/:id/edit' do #loads edit form
  @account = current_client.accounts
  erb :'/accounts/edit'
end


patch '/accounts/:id' do #updates accounts
  @account = Account.find_by_id(params[:id])
  @account.name = params[:name]
  @account.save
  redirect to "/accounts/#{@account.id}"
end



# user can make a deposit or withdawal from their account/:id page
# user submits form and this will update the account with a new transaction
post '/accounts/:id/new_transaction' do
  binding.pry
  if logged_in?
    account = Account.find_by_id(params[:id])
    if account.client == current_client
        transaction = account.transactions.create(description: params[:transaction_type], transaction_amount: params[:transaction_amount].to_i)
        if transaction.description == 'withdrawl'
          new_balance = account.balance - params[:transaction_amount].to_i
          if account.overdraft_protection && new_balance.between?(-200,0)
            new_balance = new_balance - 25
          end
          if !account.overdraft_protection && new_balance < 0
            flash[:notice] = "Withdrawl rejected - insufficient funds!"
           redirect to "/accounts/#{account.id}"
          end
        elsif transaction.description == 'deposit'
          new_balance = account.balance + params[:transaction_amount].to_i
        end
        account.update(balance: new_balance)
        redirect to "/accounts/#{account.id}"
    else
        redirect to '/accounts/show'
    end
  end
end
#
# def create_transaction(type,amount)
#
# end
#
# def create_transfer(from,to,amount)
#   self.accounts.create(name: from, name: to, amount: amount)
# end

# def valid_transaction()
#
#   if !account.overdraft_protection && new_balance < 0
#             flash[:notice] = "Withdrawl rejected - insufficient funds!"
#            redirect to "/accounts/#{account.id}"
#           end
#
#
# if !origin_account.overdraft_protection && new_balance < 0
#         flash[:notice] = "Withdrawl rejected - insufficient funds!"
#         redirect to "/accounts"
#       end
#
#
# end


post '/accounts/transfer' do

  if logged_in?
    origin_account = current_client.accounts.find_by(name: params[:account_from_name])
    destination_account = current_client.accounts.find_by(name: params[:account_to_name])

    if origin_account && destination_account && origin_account.name != destination_account.name
      # transfer
      new_balance = origin_account.balance - params[:transaction_amount].to_i
      origin_account.balance -= params[:transaction_amount].to_i
      destination_account.balance += params[:transaction_amount].to_i


      if !origin_account.overdraft_protection && new_balance < 0
        flash[:notice] = "Withdrawl rejected - insufficient funds!"
        redirect to "/accounts"
      end
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
# binding.pry
#   transfer = accounts.create_transfer(params[:account_from_name],params[:account_to_name], params[:transaction_amount].to_i)
#     if accounts.name == 'account_from_name'
#       transfer_balance = account.balance - params[:transaction_amount].to_i
#     elsif accounts.name == 'account_to_name'
#       transfer_balance = account.balance + params[:transaction_amount].to_i
#
#         accounts.update(balance: transfer_balance)
#
#           redirect to "/accounts/#{account.id}"
#     else
#         # redirect to accounts show page
#         redirect to '/accounts/show'
#     end
#   end


post '/accounts/transfer/outside' do

  if logged_in?
    origin_account = current_client.accounts.find_by(name: params[:account_from_name])
    account = Account.find(params[:email])
    destination_account = account.find_by(email: params[:account_to_email])

    if origin_account && destination_account
      # transfer
      new_balance = origin_account.balance - params[:transaction_amount].to_i
      origin_account.balance -= params[:transaction_amount].to_i
      destination_account.balance += params[:transaction_amount].to_i


      if !origin_account.overdraft_protection && new_balance < 0
        flash[:notice] = "Withdrawl rejected - insufficient funds!"
        redirect to "/accounts"
      end
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
