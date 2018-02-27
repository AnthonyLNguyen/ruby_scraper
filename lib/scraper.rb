require 'HTTParty'
require 'Nokogiri'
require 'openssl'

class Scraper
	attr_accessor :parse_page

	def initialize
		doc = HTTParty.get("http://www.cpp.edu/events/")
		@parse_page ||= Nokogiri::HTML(doc)
	end

	def get_events
		# compact removes all instances of nil in the array
		events = item_container.css(".padding").css("h3").children.map { |event| event.text }.compact
	end

	def get_date
		dates = item_container.css(".padding").css("h4").children.map { |date| date.text }.compact
	end

	def get_info
		infos = item_container.css(".padding").css("p").children.map { |info| info.text }.compact
	end


	def item_container
		parse_page.css(".event-intro")
	end

	scraper = Scraper.new
	events = scraper.get_events
	dates = scraper.get_date
	infos = scraper.get_info

	# loop from 0 to events size
	(0...events.size).each do |index|
		puts "\n===== Event: #{index+1} ====="
		puts "Event: #{events[index]}"
		puts "Date: #{dates[index]}"
		puts "Info: #{infos[index]}"
	end

end
