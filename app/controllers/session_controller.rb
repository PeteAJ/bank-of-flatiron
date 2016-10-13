require "./config/environment"
require "./app/models/client"

class SessionsController < ApplicationController


    get '/registrations/signup' do
        if !logged_in?
      erb :'/registrations/signup'
    else
      redirect to 'clients/index'
    end

    post '/registrations' do
      if params[:name] == "" || params[:email] == ""
          redirect to '/registrations/signup'
      else
      @client = Client.new(:name => params[:name], :email => params[:email], :password => params[:password])
      @client.save
      session[:client_id] = @client.id
      redirect "/sessions/login"
      	end
    end

    get '/sessions/login' do
      erb :'/sessions/login'
    end

    post '/sessions' do
      client = Client.find_by(:email => params[:email])
      if login(params[:email],[:password])
  			redirect to "/clients/index"
  		else
  			redirect to '/registrations/signup'
  		end

    end

    get '/sessions/logout' do
      redirect '/'
    end

    get '/clients/index' do
      erb :'/clients/index'
    end


end
