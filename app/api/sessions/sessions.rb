require 'grape'

module Sessions
  class API < Grape::API
    format :json

    resource :sessions do
      get do
        @user = User.where(username: params[':username'], password: params[':password']).first
        if @user
        	@user
        else
        	error!('Login or email not found', 401)
        end
      end
    end
  end
end