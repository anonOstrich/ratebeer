class AddStylesBasedOnOldStyleNamesToBeers < ActiveRecord::Migration[5.2]

  def up
    Beer.all.each do |beer|
      s_name = beer.old_style
      beer.style = Style.find_by name: s_name
      beer.save
    end

  end 

  def down 
    Beer.all.each do |beer|
      beer.style = nil
    end
  end

end
