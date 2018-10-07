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

  def is_member_of_club(bc)
    beer_clubs.find_by id: bc.id
  end
end
