require 'HTTParty'
require 'Nokogiri'
require 'openssl'

class Scraper
	attr_accessor :parse_page

	def initialize
		doc = HTTParty.get("http://www.cpp.edu/events/")
		@parse_page ||= Nokogiri::HTML(doc)
	end

	def get_cal
		cals = item_container.css(".padding").css("h3").children.map { |cal| cal.text }.compact
	end

	def get_date
		dates = item_container.css(".padding").css("h4").children.map { |cal| cal.text }.compact
	end

	def get_info
		infos = item_container.css(".padding").css("p").children.map { |cal| cal.text }.compact
	end


	def item_container
		parse_page.css(".event-intro")
	end

	scraper = Scraper.new
	cals = scraper.get_cal
	dates = scraper.get_date
	infos = scraper.get_info


	(0...cals.size).each do |index|
		puts "===== Event: #{index+1} ====="
		puts "Event: #{cals[index]}"
		puts "Date: #{dates[index]}"
		puts "Info: #{infos[index]}"
	end

end
