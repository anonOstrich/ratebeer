require 'active_support/concern'

module RatingAverage
    extend ActiveSupport::Concern

    included do
        def average_rating
            if ratings.empty?
                return 0
            end
            sum =  ratings.reduce(0) {|sigma, rating| sigma + rating.score}
            (1.0* sum) / ratings.count
        end

    end

end