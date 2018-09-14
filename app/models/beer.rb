class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average
        if self.ratings.empty? 
            return nil 
        end
       sum =  self.ratings.inject(0) {|sigma, rating| sigma + rating.score}
       (1.0* sum) / self.ratings.count
    end 

    def to_s
        "#{name} (#{brewery.name})"
    end
end
