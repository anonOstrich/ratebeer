class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  def to_s
    name
  end
end
