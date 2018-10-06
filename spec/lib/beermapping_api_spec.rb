require 'rails_helper'

describe "BeermappingApi" do 
    describe "in case of cache miss" do 

        before :each do
            Rails.cache.clear
        end
    
    it "When HTTP GET returns one entry, it is parsed and returned" do 
        canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*turku/).to_return(body:canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("turku")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Panimoravintola Koulu")
    expect(place.street).to eq("Eerikinkatu 18")
    end

    it "When HTTP GET returns no entries, empty list is returned" do 
        canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*kauhava/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})
    places = BeermappingApi.places_in("kauhava")
    expect(places.size).to eq(0)
    end

    it "When HTTP GET returns multiple entries, they are parsed and returned as list" do 
        canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>https://beermapping.com/location/12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location><location><id>21108</id><name>Captain Corvus</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/21108</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21108&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21108&amp;d=1&amp;type=norm</blogmap><street>Suomenlahdentie 1</street><city>Espoo</city><state>Etela-Suomen Laani</state><zip>02230</zip><country>Finland</country><phone>+358 50 4441272</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
        END_OF_STRING

        stub_request(:get, /.*espoo/).to_return(body:canned_answer, headers: {'Content-Type' => "text/xml"})
        places = BeermappingApi.places_in("espoo")
        expect(places.size).to eq(2)
        gallow = places.first
        expect(gallow.name).to eq("Gallows Bird")
        expect(gallow.street).to eq("Merituulentie 30")

        corvus = places.last
        expect(corvus.name).to eq("Captain Corvus")
        expect(corvus.street).to eq("Suomenlahdentie 1")
    end
end

    describe "in case of cache hit" do 
        
        before :each do 
            Rails.cache.clear
        end

        it "When one entry in cache, it is returned" do 
            canned_answer = <<-END_OF_STRING
            <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
        END_OF_STRING
          
            stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })         
            BeermappingApi.places_in("turku")
            places = BeermappingApi.places_in("turku")

            expect(places.size).to eq(1)
            expect(place.name).to eq("Panimoravintola Koulu")
            expect(place.street).to eq("Eerikinkatu 18")
            
        end

    end 
end