class ProfilesController < ApplicationController

    # GET users/:user_id/profile/new
    def new
    #Renders blank profile form
        @profile = Profile.new
    end
end