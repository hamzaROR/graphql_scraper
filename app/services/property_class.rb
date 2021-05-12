require 'open-uri'
require 'nokogiri'


class PropertyClass

	def initialize(name)
		scrape_data(name)
	end

	def scrape_data(name)
		google_search = Nokogiri::HTML.parse(open("https://www.google.com/search?q=#{name}"))
		property_name = google_search.search('span').search('h3').inner_text
		property_address = google_search.css('span')[27].inner_text
		property_time = google_search.css('span')[31].inner_text
		website_url = google_search.css('a')[20]['href']
		website_url = website_url.partition('.com').first + '.com'
		website_url = website_url.partition('?q=').last
		site_prase_search = Nokogiri::HTML.parse(open(website_url))		
		links = site_prase_search.css('a')
		gallery_url = nil
		instagram_url = nil
		facebook_url = nil
		contact_url = nil
		amenities_url = nil
		floor_plans_url = nil
		neighborhood_url = nil
		features_url = nil
		text_color = nil
		button_background_color = nil



		links.each do |link|
			if link['href'].include? '.com/gallery/'
				gallery_url = link['href']
			elsif link['href'].include? '.com/contact/'
				contact_url = link['href']
			elsif link['href'].include? 'facebook.com'
				facebook_url = link['href']
			elsif link['href'].include? 'instagram.com'
				instagram_url = link['href']
			elsif link['href'].include? 'amenities'
				amenities_url = link['href']
			elsif link['href'].include? 'floor-plans'
				floor_plans_url = link['href']
			elsif link['href'].include? 'neighborhood'
				neighborhood_url = link['href']
			elsif link['href'].include? 'features'
				features_url = link['href']
			end
		end


		property = Property.find_by(name: property_name)
		unless property.present?
			new_property = Property.create(
				name: property_name,
				address: property_address,
				website_url: property_address,
				amenities_url: amenities_url,
				floor_plan_url: floor_plans_url,
				gallery_url: gallery_url,
				contact_us_url: contact_url,
				neighborhood_url: neighborhood_url,
				features_url: features_url,
				facebook_url: facebook_url,
				instagram_url: instagram_url,
				hours: property_time,
				text_color: text_color,
				button_background_color: button_background_color
			)
		end
	end

end
