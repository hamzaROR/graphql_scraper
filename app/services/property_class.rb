require 'open-uri'
require 'nokogiri'


class PropertyClass

	def initialize(name)
		@name = name
	end

	def call
		return_back = {success:false, msg: "Unable to scrape property"}

		array_names =  @name.split(" ")
		@name.rpartition(' ').first.present? ? array_names.unshift(@name.rpartition(' ').first).uniq! : nil
		array_names.unshift(@name).uniq!
		query_names = array_names

		array_names.reverse.each do |old_name|
			query_names.unshift(old_name.delete(' ')).uniq!
		end

		array_names.reverse.each do |old_name|
			query_names.unshift(old_name + ' apartments').uniq!
		end
		array_names = query_names
	
		puts "array_namesarray_namesarray_namesarray_names"
		puts array_names
		puts "array_namesarray_namesarray_namesarray_names"

		array_names.each do |single_name|
			google_search = Nokogiri::HTML.parse(open("https://www.google.com/search?q=#{single_name}&gl=us&hl=en&pws=0"))

			property_name = nil
			website_url = nil
			property_address = nil
			property_time = nil
			if google_search.css('.deIvCb').present? && google_search.css('.VGHMXd').present? && google_search.css('.tAd8D').present?
				property_name = google_search.css('.deIvCb')[0].inner_html
				website_url = google_search.css('.VGHMXd').last['href']
				website_url = website_url.partition('.com').first + '.com'
				website_url = website_url.partition('?q=').last
				website_url.gsub!('http://www.','https://')
				property_address = google_search.css('.tAd8D')[1].inner_html
				# property_time = google_search.css('.tAd8D')[2].inner_html
				property_time = "Wednesday | 9AM–6PM | Thursday | 9AM–6PM | Friday | 9AM–6PM | Saturday | 10AM–5PM | Sunday | 1–5PM | Monday | 9AM–6PM | Tuesday | 9AM–6PM"
			end

			puts "single_namesingle_namesingle_namesingle_name"
			puts single_name
			puts "property_timeproperty_timeproperty_timeprope"
			puts property_time
			puts "website_urlwebsite_urlwebsite_urlwebsite_url"
			puts website_url
			puts "property_addressproperty_addressproperty_add"
			puts property_address
			puts "property_nameproperty_nameproperty_nameprope"
			puts property_name
			puts "property_nameproperty_nameproperty_nameprope"




			property = Property.find_by(name: property_name)
			unless property.present?
				if property_time.present? && website_url.present? && property_address.present?
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
					other_links = ""

					links.each do |link|
						if link['href'].present?
							if link['href'].include? 'gallery'
								if link['href'][0] == "/"
									gallery_url = website_url + link['href']
								else
									gallery_url = link['href']
								end
							elsif link['href'].include? 'contact'
								if link['href'][0] == "/"
									contact_url = website_url + link['href']
								else
									contact_url = link['href']
								end
							elsif link['href'].include? 'facebook'
								if link['href'][0] == "/"
									facebook_url = website_url + link['href']
								else
									facebook_url = link['href']
								end
							elsif link['href'].include? 'instagram'
								if link['href'][0] == "/"
									instagram_url = website_url + link['href']
								else
									instagram_url = link['href']
								end
							elsif link['href'].include? 'amenities'
								if link['href'][0] == "/"
									amenities_url = website_url + link['href']
								else
									amenities_url = link['href']
								end
							elsif link['href'].include? 'floor'
								if link['href'][0] == "/"
									floor_plans_url = website_url + link['href']
								else
									floor_plans_url = link['href']
								end
							elsif link['href'].include? 'neighborhood'
								if link['href'][0] == "/"
									neighborhood_url = website_url + link['href']
								else
									neighborhood_url = link['href']
								end
							elsif link['href'].include? 'features'
								if link['href'][0] == "/"
									features_url = website_url + link['href']
								else
									features_url = link['href']
								end
							else
								if link['href'][0] == "/" || link['href'][0..4] == "https"
									if link['href'][0] == "/"
										other_links = other_links + ', ' + (website_url + link['href'])
									else
										other_links = other_links + ', ' + link['href']
									end
								end

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
					return_back = {success:true, msg: "Property alredy in system", property: property}
					return return_back
				end
			end
		end
		return return_back
	end

end
