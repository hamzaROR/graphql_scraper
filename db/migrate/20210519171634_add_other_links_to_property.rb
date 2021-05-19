class AddOtherLinksToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :other_links, :text  	
  end
end
