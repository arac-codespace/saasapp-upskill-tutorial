class UsersController < ApplicationController
    before_action :authenticate_user!
    
    #GET to users/:id
    def show
        @user = User.find(params[:id])
    end
    
    
    # .includes will combine the users and profiles table into one query for optimization.
    def index
        @users = User.includes(:profile)
    end
end