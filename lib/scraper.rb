require 'httparty'
require 'nokogiri'
require 'openssl'

class Scraper
	# shortcut for writing
	#
	# def parser=(val)
	#  	@parser = val
	# end
	#
	# def parser
	#  	@parser
	# end
	#
	attr_accessor :parser

	def initialize
		page = HTTParty.get("http://www.cpp.edu/events/")
		# use @ for instance variable which is avaible to all methods in the class
		# a ||= b is equivalent to a || a = b
		@parser ||= Nokogiri::HTML(page)
	end

	#Define container to search through
	def container
		parser.css(".event-intro")
	end

	def get_events
		# compact removes all instances of nil in the array
		events = container.css(".padding").css("h3").children.map { |event| event.text }.compact
	end

	def get_date
		dates = container.css(".padding").css("h4").children.map { |date| date.text }.compact
	end

	def get_info
		infos = container.css(".padding").css("p").children.map { |info| info.text }.compact
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
