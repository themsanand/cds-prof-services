class UsersController < ApplicationController
  before_filter :current_user
  before_action :current_user
  
  def show
    if User.exists?(params[:id]) == false
      flash[:notice] = "The user you entered does not exist."
      redirect_to @current_user
    else
      id = params[:id]
      @own_profile = false
      @user = User.find(id)
      @dogs = Dog.where(user_id: @user.uid)
      
      if @user == @current_user
        @own_profile = true
        @stars = Star.where(user_id: session[:user_id])
        @staredDogs = []
        @stars.each do |s|
          @staredDogs.push(Dog.find(s.dog_id))
        end
      end
      render 'show'
    end
  end

  def edit
    if  User.exists?(params[:id]) == false || User.find(params[:id]) != @current_user
      flash[:notice] = "You may only edit your own profile."
      redirect_to @current_user
    elsif params[:user] != nil and @current_user.update_attributes(user_params)
      flash[:notice] = "Profile successfully updated."
      redirect_to @current_user
    else
      render 'edit'
    end
  end

  def destroy
    @current_user.destroy
    # Don't like this... I wanted to redirect to sessions#destroy, but redirect_to doesn't do DELETE methods
    session[:user_id] = nil
    redirect_to root_path()
  end

  def stars
    if !current_user.nil? and current_user.id != params[:id].to_i
      redirect_to(stars_user_path(current_user)) and return
    end
    @dogs = User.find_by_id(params[:id]).starred_dogs
  end
  
end
