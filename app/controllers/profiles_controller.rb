class ProfilesController < ApplicationController
    before_action :authenticate_user! #Devise method prevents unregistered users from using any of the ProfilesController functionalities
    before_action :only_current_user # Self-made function defined at the private section
    
    # GET users/:user_id/profile/new
    def new
    #Renders blank profile form
        @profile = Profile.new
    end
    
    # POST to /:user_id/profile
    def create
        # Ensures that we have the user who is filling out the form
        @user = User.find(params[:user_id])
        # Create profile linked to this specific user
        @profile = @user.build_profile(profile_params)
        if @profile.save
            flash[:success] = "Profile Updated"
            redirect_to user_path(id: params[:user_id])
        else
            render action: :new
        end
    end
    
    # GET requests for /users/:users_id/profile/edit
    def edit
        @user = User.find(params[:user_id])
        @profile = @user.profile
    end
    
    # PUT requests for /user/:user_id/profile
    def update
        # Retrieve the users from the database
        @user = User.find(params[:user_id])
        # Retrieve the user's profile
        @profile = @user.profile
        # Mass assign edited profile attributes and save (update)
        if @profile.update_attributes(profile_params)
            flash[:success] = "Profile updated!"
            # Redirect to the user's profile
            redirect_to user_path(id: params[:user_id])
        else
            render action: :edit
        end
    end
    
    
    private
        def profile_params
            params.require(:profile).permit(:first_name, :last_name, :avatar, :job_title, :phone_number, :contact_email, :description)
        end
        
        def only_current_user
            @user = User.find(params[:user_id])
            redirect_to(root_url) unless @user == current_user #(Devise method)
        end
end