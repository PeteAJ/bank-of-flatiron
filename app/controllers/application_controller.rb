require './config/environment'
require 'sinatra/flash'


class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }
  register Sinatra::Flash
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

      def validate_overdraft_transaction(origin_account, new_balance, account_id=nil)
        if !origin_account.overdraft_protection && new_balance < 0
          flash[:notice] = "Withdrawl rejected - insufficient funds!"
          if !account_id
            redirect to "/accounts"
          else
            redirect to "/accounts/#{account_id}"
          end
        end
      end


      def logout
        session.clear
      end

end
end
