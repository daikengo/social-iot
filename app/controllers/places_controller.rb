class PlacesController < ApplicationController
  before_filter :require_user, :except => [ :show, :edit, :index, :nearbys ]
  # GET /places
  # GET /places.json
  def index
   # if !current_user.nil? and  current_user.admin?
=begin
    puts "dentro index!!!!"
    if params[:latitude]
     @places=Place.near([params[:latitude],params[:longitude]],params[:distance])
    else
      render :text => 'error'
=end
      redirect_to(root_path) and return#@places = Place.all
=begin
    end
    respond_to do |format|
      #format.html  #index.html.erb
      format.json { render json: @places, :only =>[:name,:latitude, :longitude, :distance] }
    end
=end
  #else
  #  redirect_to(root_path)
  #end
  end
  def nearbys
    if params[:latitude]
      @places=Place.near([params[:latitude],params[:longitude]],params[:distance])
    else
      render :text => 'error'
      #redirect_to(root_path) and return#@places = Place.all
    end
    respond_to do |format|
      #format.html  #index.html.erb
      format.json { render json: @places, :only =>[:name,:latitude, :longitude, :range,  :distance] }
      format.xml  {render xml: @places, :only =>[:name,:latitude, :longitude, :range, :distance]}
    end
  end
  # GET /places/1
  # GET /places/1.json
  def show

=begin
     @place = Place.find(params[:id])

     respond_to do |format|
       format.html  show.html.erb
       format.json { render json: @place }
     end
=end


  end

  # GET /places/new
  # GET /places/new.json
  def new
    @place = Place.new
    @allplaces  = Place.all.to_gmaps4rails
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(params[:place])
    @place.creator_id=current_user
    respond_to do |format|
      if @place.save
        #hierarchify

        if Group.find_by_place_id(@place.id).nil?
          @group=Group.new
          @group.place_id=@place.id
          if @group.save
            status_group=1
          end
        end
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render json: @place, status: :created, location: @place }
      else
        format.html { render action: "new" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def hierarchify

    if !@place.nil?
      @neighbour=@place.nearbys(30)
      @mark=@place.nearbys(30).to_gmaps4rails

    else
      puts "niente da dire...."
    end
    #inserisce come superplace il luogo più vicino che lo include
    @neighbour.each do |d|

      if d.distance*1000 < d.range and @place.range < d.range and d.creator_id == @place.creator_id and @place.work == d.work and @place.public == d.public and @place.home == d.home

        status=0
        @place.superplace=d.id
        if @place.save
          status=1
          break
        end

      end


    end

    @neighbour.each do |d|
      if d.distance*1000 < @place.range and d.range < @place.range and d.creator_id == @place.creator_id and @place.work == d.work and @place.public == d.public and @place.home == d.home
        @placetemp=Place.find(d.id)
        @placetemp.superplace=@place.id
        status=0
        if !@placetemp.nil?
          if @placetemp.save
            status=1
          end
        end
      end

    end



  end


  # PUT /places/1
  # PUT /places/1.json
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end
end

private

def verify_is_admin
  (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
end