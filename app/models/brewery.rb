class Brewery < ApplicationRecord
    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    def print_report
        puts name
        puts "established at year #{year}"
        puts "number of beers #{beers.count}"
    end


    def restart
        self.year = 2018
        puts "changed year to #{year}"
    end

    def to_s
        "#{name} (est. #{year})"
    end

    def average_rating
        if ratings.empty?
            return 0
        end
        sum =  ratings.reduce(0) {|sigma, rating| sigma + rating.score}
        (1.0* sum) / ratings.count
    end
end
