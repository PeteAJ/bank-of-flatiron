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
  			!current_client
  		end

  		def current_client
        @current_client ||= Client.find_by(session[:client_id])
  	  end

      def login(email, password)
        client = Client.find_by(:email => email)
        if  client && client.authenticate(password)
        session[:email] = client.email
        else
        redirect '/sessions/login'
      end
    end

      def logout
        session.clear
      end

end
end
