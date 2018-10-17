require 'rails_helper'

describe "Beerlist page" do

before :all do
  Capybara.register_driver :selenium do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: ['headless', 'disable-gpu']  }
    )

    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      desired_capabilities: capabilities      
  end
  WebMock.disable_net_connect!(allow_localhost: true) 
end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager", description: "Default"
    @style2 = Style.create name:"Rauchbier", description: "Default"
    @style3 = Style.create name:"Weizen", description: "Default"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do 
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    expect(page).to have_content "Nikolai"
  end

  it "shows beers by default sorted by name", js:true do 
    visit beerlist_path
    row = find('table').find('tr:nth-child(2)')
    expect(row).to have_content "Fastenbier"
    row = find('table').find('tr:nth-child(3)')
    expect(row).to have_content "Lechte Weisse"
    row = find('table').find('tr:nth-child(4)')
    expect(row).to have_content "Nikolai"
  end

  it "can be sorted by style name", js:true do 
    visit beerlist_path
    row = find('table').find('tr:nth-child(2)')
    click_link('style')
    row = find('table').find('tr:nth-child(2)')
    expect(row).to have_content "Nikolai"
    row = find('table').find('tr:nth-child(3)')
    expect(row).to have_content "Fastenbier"
    row = find('table').find('tr:nth-child(4)')
    expect(row).to have_content "Lechte Weisse"
  end 

  it "can be sorted by brewery name", js:true do 
    visit beerlist_path
    click_link('brewery')
    row = find('table').find('tr:nth-child(2)')
    expect(row).to have_content "Lechte Weisse"
    row = find('table').find('tr:nth-child(3)')
    expect(row).to have_content "Nikolai"
    row = find('table').find('tr:nth-child(4)')
    expect(row).to have_content "Fastenbier"
  end

end