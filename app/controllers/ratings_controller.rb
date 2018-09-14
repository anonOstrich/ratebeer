class RatingsController < ApplicationController
    def index
        @ratings = Rating.all
    end

    def new
        @beers = Beer.all
        @rating = Rating.new
    end

    def create
        Rating.create params.require(:rating).permit(:score, :beer_id)
        redirect_to ratings_path
    end 
end