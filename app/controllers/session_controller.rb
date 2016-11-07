require "./config/environment"
require "./app/models/client"

class SessionsController < ApplicationController


    get '/registrations/signup' do
    if !logged_in?
    erb :'/registrations/signup'
    else
    redirect to "clients/index"
      end
    end

    post '/registrations' do
    if params[:name] == "" || params[:email] == "" || params[:password] == ""
    redirect to "/registrations/signup"
    else
    @client = Client.new(params)
    if @client.save
    session[:client_id] = @client.id
    redirect to '/accounts'
    else
    flash[:notice] = "Please enter name, email and password."
    redirect "/registrations/signup"
        end
      end
    end

    get '/sessions/login' do
    erb :'/sessions/login'
    end

    post '/sessions' do
    client = Client.find_by_email(params[:email])
    if client && client.authenticate(params[:password])
    session[:client_id] = client.id
    redirect to "/clients/#{client.id}"
    else
    flash[:notice] = "Please enter email and password."
    redirect '/login'
      end
    end

    get '/sessions/logout' do
    logout
    redirect "/"
    end

    get '/clients/index' do
    erb :'/clients/index'
    end


end
