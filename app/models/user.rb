class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /.*(([A-Z].*[0-9])|([0-9].*[A-Z])).*/ }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer.style
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer.brewery
  end

  def member_of_club?(b_club)
    beer_clubs.find_by id: b_club.id
  end

  def self.top_number_of_ratings(n)
    sorted_nums_of_ratings_in_desc_order = User.all.sort_by{ |u| -u.ratings.count }
    sorted_nums_of_ratings_in_desc_order.first(n)
  end
end
