module Helpers

    def sign_in(credentials)
        visit signin_path
        fill_in('username', with: credentials[:username])
        fill_in('password', with: credentials[:password])
        click_button('Log in')

    end

    def create_beer_with_rating(object, score)
        beer = FactoryBot.create(:beer)
        beer.style = object[:style] if object[:style]
        beer.brewery = object[:brewery] if object[:brewery]
        beer.save 
        FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
        beer
      end 
      
      def create_beers_with_many_ratings(object, *scores)
        scores.each do |score|
          create_beer_with_rating(object, score)
        end
      end
      
      def create_beers_with_breweries_and_many_ratings(object, *brewery_scores)
        brewery_scores.each do |bs|
          object[:brewery] = bs[0]
          create_beer_with_rating(object, bs[1])
        end 
      end 
      
      def create_beers_with_styles_and_many_ratings(object, *style_scores)
        style_scores.each do |ss|
          object[:style] = ss[0]
          create_beer_with_rating(object, ss[1])
        end
    end

end