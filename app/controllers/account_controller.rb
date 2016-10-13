class AccountsController < ApplicationController

get '/accounts/new' do #load new acount form
end

get '/accounts' do #loads index
end

get '/accounts/:id' do #loads show 1 Account
end

get 'accounts/:id/edit' do #loads edit form\
end

patch '/accounts/:id' do #updates accounts
end

post '/accounts' do #creates an AccountsControllere
end

delete '/accounts/:id/delete' do #deletes account - exclude?
end
