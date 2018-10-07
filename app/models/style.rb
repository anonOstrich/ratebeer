class Style < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true

    has_many :beers
end
