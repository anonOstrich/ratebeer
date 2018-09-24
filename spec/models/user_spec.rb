require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end 

  it "is not saved without a password" do 
    user = User.create username: "Pekka"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short a password" do
    user = User.create username: "Pekka", password: "Na2", password_confirmation: "Na2"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password containing only letters" do 
    user = User.create username: "Pekka", password: "SALAsana", password_confirmation: "SALAsana"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining the favorite style" do 
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only one rated if only one rated" do 
      create_beer_with_rating({user: user}, 10)
      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest rating if several rated" do 
      create_beers_with_styles_and_many_ratings({user: user}, ["IPA", 10], ["Lager", 15], ["Stout", 14])
      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest rating if several styles have many ratings" do 
      create_beers_with_styles_and_many_ratings({user: user}, ["IPA", 5], ["Stout", 49], ["Lager", 37], ["IPA", 30], ["IPA", 40], ["Stout", 10], ["Lager", 35])
      expect(user.favorite_style).to eq("Lager")
    end

  end 

  describe "favorite brewery" do 
  end


  describe "favorite beer" do 
    let(:user) { FactoryBot.create(:user)}

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end
    
    it "without ratings does not have a favorite beer" do 
      expect(user.favorite_beer).to eq(nil)
    end 

    it "is the only rated if only one rated" do 
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do 
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)
      expect(user.favorite_beer).to eq(best)
    end

  end

  describe "with a proper password" do 
    let(:user) { FactoryBot.create(:user) }
    let(:test_brewery) {FactoryBot.create(:brewery) }
    let(:test_beer) { FactoryBot.create(:beer) }

  it "is saved" do 
    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "and two ratings, has the correct average rating" do
    rating = FactoryBot.create(:rating, score: 10, user: user)
    rating2 = FactoryBot.create(:rating, score: 20, user: user)

    user.ratings << rating
    user.ratings << rating2

    expect(user.ratings.count).to eq(2)
    expect(user.average_rating).to eq(15.0)
  end

  end







end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  beer.style = object[:style] if object[:style]
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end 

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beers_with_styles_and_many_ratings(object, *style_scores)
  style_scores.each do |ss|
    object[style: ss[0]]
    create_beer_with_rating(object, ss[1])
  end

end