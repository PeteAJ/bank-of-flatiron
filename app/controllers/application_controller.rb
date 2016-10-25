require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }
  #helpers ApplicationController

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
  			!!current_client
  		end

  		def current_client
        @current_client ||= Client.find_by_id(session[:client_id])
  	  end



      def logout
        session.clear
      end

end
end
