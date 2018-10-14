class Style < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :description, presence: true

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }
    sorted_by_rating_in_desc_order.first(n)
  end
end
