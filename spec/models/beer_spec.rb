require 'rails_helper'

include Helpers

RSpec.describe Beer, type: :model do
  let(:test_brewery) {Brewery.new name: "test brewery", year: 2000}
  
  it "with proper information, is stored" do 
    beer = Beer.create name: "test beer", style: create_style_with_name("test style"), brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "without name, is not stored" do 
    beer = Beer.create style: create_style_with_name("test style"), brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "without style, is not stored" do 
    beer = Beer.create name: "test beer", brewery: test_brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end

