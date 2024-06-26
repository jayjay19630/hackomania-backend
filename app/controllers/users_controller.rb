class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create, :login, :appliances]

    def index
        users = User.all
        render json: users
    end

    def show
        begin
            @user = User.find(params[:id])
            records = Record.where(user_id: @user.id).order(created_at: :desc).limit(7)
            render json: {user: @user, energy_records: records }
        rescue 
            render json: {error: 'User not found'}
        end 
    end

    def destroy
            @user = User.find(params[:id])
            @user.destroy
     
    end

    #route for signup
    def create
        @user = User.new(user_params)
        @user.health = 100
        @user.status =  "healthy"
        @user.currency = 0
        if @user.save
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}, status: 201
        else
            render json: { error: "Username already taken" }, status: 422
        end
    end

    #route for login
    def login
        @user = User.find_by(username: params[:user][:username])
        if @user 
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else 
            render json: { error: "Invalid username or password" }, status: 422
        end
    end

    def appliances
        @user = User.find(params[:id])
        if @user
            @user.aircon = params[:appliances][:aircon]
            @user.laundry = params[:appliances][:laundry]
            @user.fridge = params[:appliances][:fridge]
            @user.others = params[:appliances][:others]
            @user.save
        end
    end

    def generate_goals
        @user = User.find_by(params[:user_id])
        if @user
            goal = Goal.new()
            goal.goal = "Sample"
            goal.save
            render json: {goal:  goal}
        end
    end

    private 
        def user_params
            params.require(:user).permit(:username, :password)
        end

        def appliance_params
            params.required(:appliances).permit(:aircon, :laundry, :fridge, :others)
        end
end