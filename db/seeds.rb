
2.times do 
	Property.create(name: Faker::Company.name,
	address: Faker::Address.full_address,
	website_url: Faker::Internet.url,
	amenities_url: Faker::Internet.url,
	floor_plan_url: Faker::Internet.url,
	gallery_url: Faker::Internet.url,
	contact_us_url: Faker::Internet.url,
	neighborhood_url: Faker::Internet.url,
	features_url: Faker::Internet.url,
	facebook_url: Faker::Internet.url,
	instagram_url: Faker::Internet.url,
	text_color: Faker::Color.hex_color,
	button_background_color: Faker::Color.hex_color	
	)
end