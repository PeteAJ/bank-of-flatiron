require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "my_secret"
  end

  get "/" do
    erb :index
  end


  helpers do
  		def logged_in?
  			!!session[:client_id]
  		end

  		def current_user
  			Client.find(session[:client_id])
  		end
  	end

    def login(email, password)
        client = Client.find_by(:email => email)
      if  client && client.authenticate(params[:password])
          session[:client_id] = client.id
      #if client && client.authenticate(password)
      #  session[:email] = client.email
      else
        redirect '/sessions/login'
  end

end
