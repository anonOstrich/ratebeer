require 'rails_helper'

include Helpers

describe "User" do 

    before :each do 
       FactoryBot.create :user
    end

    it "when signed up with good credentials, is added to the system" do 
        visit signup_path
        fill_in('user_username', with: 'Brian')
        fill_in('user_password', with: 'Secret55')
        fill_in('user_password_confirmation', with: 'Secret55')
        
        expect{
            click_button('Create User')
        }.to change{User.count}.by(1)
    end 

    describe "who has signed up" do 

        it "can sign in with the ride credentials" do 
            sign_in username: "Pekka", password: 'Foobar1'

            expect(page).to have_content 'Welcome back!'
            expect(page).to have_content 'Pekka'
        end

        it "is redirected back to signin form if wrong credentials given" do 
            sign_in username: 'Pekka', password: 'wrong'


            expect(current_path).to eq(signin_path)
            expect(page).to have_content 'Username and/or password mismatch'
        end 

    end

    it "has favorites displayed on their page" do 
        user = User.first
        brewery1 = FactoryBot.create(:brewery, name: "Jaska's Brewery")
        brewery2 = FactoryBot.create(:brewery, name: 'Basic Brewery')
        create_beer_with_rating({user: user, style: create_style_with_name('IPA'), brewery: brewery1} , 35)
        create_beer_with_rating({user: user, style: create_style_with_name('Pale Ale'), brewery: brewery2}, 39)
        visit user_path(user)
        expect(page).to have_content 'Favorite brewery: Basic Brewery'
        expect(page).to have_content 'Favorite beer style: Pale Ale'
    end
end