class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  # require 'dog_form_filler'
  

  # GET /dogs
  # GET /dogs.json
  def index
    #@user = User.find(session[:user_id])
    @dogs = Dog.all
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
    @user = User.find(session[:user_id])
    @dog = Dog.find(params[:id])
  end

  # GET /dogs/new
  def new
    @user = User.find(session[:user_id])
    @dog = Dog.new
    @all_mixes = Mix.all
    @size = Size.all
    @energy = EnergyLevel.all
    # @personality = Personality.all
  end

  # GET /dogs/1/edit
  def edit
    #@form_filler = DogViewHelper.new(nil, nil, false)
    @dog = Dog.find(params[:id])
    @pictures = @dog.image
    #@form_filler.dog_view_update(@dog)
    @action = :update
    @method = :put
  end

  # POST /dogs
  # POST /dogs.json
  # def create
  #   @dog = Dog.new(dog_params)

  #   respond_to do |format|
  #     if @dog.save
  #       format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
  #       format.json { render :show, status: :created, location: @dog }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @dog.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  
  def create
    # @values[:mix] = selected[:mix] if selected[:mix]
    # @mix =  Mix.find(value: dog_params['mixes'])
    # @personality = Personality.find(params[:personality])
    # @pic = Picture.new(dog_params[:image])
    @dog = Dog.new(dog_params)
    @user = User.find(session[:user_id])
    @size = Size.find(dog_params['size_id'])
    @energy_level = EnergyLevel.find(dog_params['energy_level_id'])
    @user.dogs.create(user: @user)
    @size.dogs.create(size: @size)
    @energy_level.dogs.create(energy_level: @energy_level)
    params[:mixes].each do |s| 
      @dog.mixes << Mix.find_by_value(s)
    end
  # Debug(params)
    
    # @dog.mixes << @mix
    # @recipe.categories << @category

    if @dog.save
      redirect_to @user
    else
      render 'new'
    end 
  end
  
  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      # params.fetch(:dog, :name)
      params.require(:dog).permit(:dog, :image, :mixes, :photo, :name, :dob, :energy_level_id, :description, :motto, :fixed, :health, :availability, :gender, :size_id, :energy_level_id, :user_id)
    end
end

