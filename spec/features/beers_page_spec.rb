require 'rails_helper'

include Helpers

describe "Beer" do 
    let!(:brewery) { FactoryBot.create :brewery, name: 'oma panimo' }

    

    it "can be added with valid name" do 
        visit new_beer_path
        select('oma panimo', from: 'beer[brewery_id]')
        select('IPA', from: 'beer[style]')
        fill_in('beer[name]', with: 'Test beer')

        expect{
            click_button('Create Beer')
        }.to change{Beer.count}.from(0).to(1)

        expect(brewery.beers.count).to eq(1)
        expect(Beer.first.name).to eq('Test beer')
    end

    it "cannot be added with invalid name" do 
        visit new_beer_path
        select('oma panimo', from: 'beer[brewery_id]')
        select('IPA', from: 'beer[style]')
        fill_in('beer[name]', with: '')
        

        click_button('Create Beer')
        
        expect(Beer.count).to eq(0)
        expect(brewery.beers.count).to eq(0)
    end

end 