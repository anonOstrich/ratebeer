require 'rails_helper'

describe "Places" do

    before :each do 
        stub_request(:get, "http://api.apixu.com/v1/current.json?key=97f71ae642024312b08135335180710&q=kumpula").
        with(
          headers: {
            'Accept'=>'*/*',
            'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: "", headers: {})

        allow(WeatherApi).to receive(:weather_in).with("kumpula").and_return(nil)
    end

    it "if one is returned by the API, it is shown on the page" do
        allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
            [ Place.new( name:"Oljenkorsi", id:1)  ]
        )


        visit places_path
        fill_in('city', with:'kumpula')
        click_button "Search"
        expect(page).to have_content "Oljenkorsi"
    end

    it "if multiple are returned by the API, they are shown on the page" do 
        allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
            [Place.new( name:"Oljenkorsi", id:1), 
            Place.new(name:"Kanttarelli", id:2), 
            Place.new(name:"Aromaatti", id:3)]
        )

        visit places_path
        fill_in('city', with:'kumpula')
        click_button "Search"
        expect(page).to have_content "Oljenkorsi"
        expect(page).to have_content "Kanttarelli"
        expect(page).to have_content "Aromaatti"
    end

    it "if none are returned by the API, message is shown on the page" do 
        allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
            []
        )
        visit places_path
        fill_in('city', with:'kumpula')
        click_button "Search"
        expect(page).to have_content "No locations in kumpula"
    end

end