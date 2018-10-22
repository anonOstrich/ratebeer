class RatingsController < ApplicationController
  def index
    @beers = Rails.cache.fetch("beer top 3", expires_in: 5.minutes) do
      Beer.top(3)
    end

    @users = Rails.cache.fetch("user top 3", expires_in: 5.minutes) do
      User.top(3)
    end

    @styles = Rails.cache.fetch("style top 3", expires_in: 5.minutes) do
      Style.top(3)
    end

    @breweries = Rails.cache.fetch("brewery top 3", expires_in: 5.minutes) do
      Brewery.top(3)
    end

    @ratings = Rails.cache.fetch("rating recent", expires_in: 5.minutes) do
      Rating.recent
    end
  end

  def new
    @beers = Beer.all
    @rating = Rating.new
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in'
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
