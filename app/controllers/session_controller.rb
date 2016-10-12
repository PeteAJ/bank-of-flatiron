class SessionsController < ApplicationController


    get '/registrations/signup' do
      erb :'/registrations/signup'
    end

    post '/registrations' do

      redirect '/clients/index'
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
