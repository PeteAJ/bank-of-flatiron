class ClientsController < ApplicationController

get '/clients/new' do #loads new client form
end

get '/clients' do #loads index
end

get '/clients/:id' do #show 1 client
end

get '/clients/:id/edit' do #edit client form
end

patch '/clients/:id/' do #updates clients
end

post '/clients' do #creates a client
end
