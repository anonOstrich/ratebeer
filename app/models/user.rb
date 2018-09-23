class User < ApplicationRecord
    include RatingAverage
    validates :username, uniqueness: true, 
                         length: { minimum: 3 , maximum: 30}

    has_many :ratings
    has_many :users, through: :ratings
end
