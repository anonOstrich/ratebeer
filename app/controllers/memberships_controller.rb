class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @beer_clubs = BeerClub.all.select{ |bc| bc.users.include? current_user }
    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
  end

  def toggle_activity
    membership = Membership.find params[:id]
    membership.confirmed = true
    membership.save
    redirect_to BeerClub.find(membership.beer_club_id), notice: "Membership has been granted!"
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    existing_memberships = Membership.all.select{ |m| m.beer_club_id == params[:membership][:beer_club_id].to_i && m.user_id == current_user.id }
    if existing_memberships.empty?
      @membership.user_id = current_user.id if current_user
      @membership.confirmed = false
    end

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beer_club_path(membership_params[:beer_club_id]), notice: "#{current_user.username} welcome to the club!" }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all.select{ |bc| bc.users.include? current_user }

        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    mem_name = @membership.beer_club.name
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user.id), notice: "Membership in #{mem_name} ended" }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def membership_params
    params.require(:membership).permit(:beer_club_id, :user_id)
  end
end
