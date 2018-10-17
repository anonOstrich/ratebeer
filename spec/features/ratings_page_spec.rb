
require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in username: "Pekka", password: "Foobar1"
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')


    expect{
      click_button 'Create Rating'
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "are displayed on the ratings page correctly " do
    scores = [10, 30, 47, 17, 18]
    create_beers_with_many_ratings({user: user}, *scores)
    visit ratings_path

    scores.each do |s|
      expect(page).to have_content(s)
    end

  end

  it 'are displayed on users page correctly' do 
    user2 = FactoryBot.create :user, username: "Jarkko", password: "Kissa2", password_confirmation: "Kissa2"
    scores = [10, 30, 20, 40, 50]
    scores2 = [5, 15, 25, 35, 45]
    create_beers_with_many_ratings({user: user}, *scores)
    create_beers_with_many_ratings({user: user2}, *scores2)
    visit user_path(user)
    scores.each do |score|
      expect(page).to have_content("anonymous #{score} ")
    end
    expect(page).to have_content('Has made 5 ratings, average rating 30')

    scores2.each do |score|
      expect(page).not_to have_content("anonymous #{score} ")
    end
  end

  it 'is removed from database when user deletes' do 
    create_beers_with_many_ratings({user: user}, 10, 20, 30)
    visit user_path(user)
    expect{
      find_link('delete',  {href: '/ratings/2'}).click
    }.to change{Rating.count}.from(3).to(2)

    expect(Rating.find_by score: 20).to eq(nil)
  end
end
