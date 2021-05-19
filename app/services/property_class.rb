require 'open-uri'
require 'nokogiri'


class PropertyClass

	def initialize(name)
		@name = name
		@return_back = {success:false, msg: "Unable to scrape property"} 
	end

	def call		
		array_names = get_all_names_to_query(@name)
		array_names.each do |single_name|
			google_search = Nokogiri::HTML.parse(open("https://www.google.com/search?q=#{single_name}&gl=us&hl=en&pws=0"))
			property_name, website_url, property_address, property_time = [nil] * 4
			if google_search.css('.deIvCb').present? && google_search.css('.VGHMXd').present? && google_search.css('.tAd8D').present?
				property_name = google_search.css('.deIvCb')[0].inner_html
				website_url = google_search.css('.VGHMXd').last['href']
				website_url = website_url.partition('.com').first + '.com'
				website_url = website_url.partition('?q=').last
				website_url.gsub!('http://www.','https://')
				property_address = google_search.css('.tAd8D')[1].inner_html
				property_time = google_search.css('.tAd8D')[2].inner_html
			end

			property = Property.find_by(name: property_name)
			unless property.present?
				if property_time.present? && website_url.present? && property_address.present?
					site_prase_search = Nokogiri::HTML.parse(open(website_url))		
					links = site_prase_search.css('a')
					gallery_url, instagram_url, facebook_url, contact_url, amenities_url, floor_plans_url, neighborhood_url, features_url, text_color , button_background_color = [nil] * 10
					other_links = ""
					links.each do |link|
						if link['href'].present?
							if link['href'].include? 'gallery'
								gallery_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'contact'
								contact_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'facebook'
								facebook_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'instagram'
								instagram_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'amenities'
								amenities_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'floor'
								floor_plans_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'neighborhood'
								neighborhood_url = get_link(link['href'],website_url)
							elsif link['href'].include? 'features'
								features_url = get_link(link['href'],website_url)
							else
								other_links = get_other_link(link['href'],website_url,other_links)
							end
						end
					end

					property = Property.create(
						name: property_name,
						address: property_address,
						website_url: website_url,
						amenities_url: amenities_url,
						floor_plan_url: floor_plans_url,
						gallery_url: gallery_url,
						contact_us_url: contact_url,
						neighborhood_url: neighborhood_url,
						features_url: features_url,
						facebook_url: facebook_url,
						instagram_url: instagram_url,
						time: property_time,
						other_links: other_links,
						text_color: text_color,
						button_background_color: button_background_color
					)
					@return_back = {success:true, property: property}
					return @return_back
				end
			end
		end
		return @return_back
	end


	def get_all_names_to_query(name)
		query_names =  name.split(" ")
		name.rpartition(' ').first.present? ? query_names.unshift(name.rpartition(' ').first).uniq! : nil
		query_names.unshift(name).uniq!
		array_names = query_names
		query_names.reverse.each do |old_name|
			array_names.unshift(old_name.delete(' ')).uniq!
			array_names.unshift(old_name + ' apartments').uniq!
		end
		array_names
	end

	def get_link(link,website_url)
		url = link
		url = website_url + link if link[0] == "/"
		url
	end

	def get_other_link(link,website_url,other_links)
		if link[0] == "/" || link[0..4] == "https" 
			if link[0] == "/"
				url = (website_url + link)
				unless other_links.include? url
					if url.include? website_url
						other_links = other_links + ', ' + url
					end
				end
			else
				url = link
				unless other_links.include? url
					if url.include? website_url
						other_links = other_links + ', ' + url
					end
				end
			end
		end								
		other_links
	end

end
