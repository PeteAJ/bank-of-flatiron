require "./config/environment"
require "./app/models/client"

class SessionsController < ApplicationController


    get '/registrations/signup' do
      erb :'/registrations/signup'
    end

    post '/registrations' do
      client = Client.new(:name => params[:name], :email => params[:email], :password => params[:password])
      if client.save
      		redirect "/sessions/login"
      	else
      		redirect "/"
      	end
    end

    get '/sessions/login' do
      erb :'/sessions/login'
    end

    post '/sessions' do
      client = Client.new(:email => params[:email], :password => params[:password])
  		if client.save
  			redirect "/clients/new"
  		else
  			redirect "/"
  		end

    end

    get '/sessions/logout' do
      redirect '/'
    end

    get '/clients/index' do
      erb :'/clients/index'
    end


end
