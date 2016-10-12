require "./config/environment"
require "./app/models/client"

class SessionsController < ApplicationController


    get '/registrations/signup' do
      erb :'/registrations/signup'
    end

    post '/registrations' do
      client = Client.new(:name => params[:name], :email => params[:email], :password => params[:password])
      client.save
  	if client.save
      redirect '/clients/index'
    else
      redirect '/'
    end
    end

    get '/sessions/login' do
      erb :'sessions/login'
    end

    post '/sessions' do
      redirect '/clients/index'
    end

    get '/sessions/logout' do
      redirect '/'
    end

    get '/clients/index' do
      erb :'/clients/index'
    end


end
