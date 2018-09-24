class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @beers = Beer.all
    @rating = Rating.new
  end

  def create


    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    if current_user.nil?
      redirect signin_path, notice: 'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      session[:last_rating] = "#{@rating.beer.name} #{@rating.score} points"
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
