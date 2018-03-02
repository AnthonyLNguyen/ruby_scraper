#!/usr/bin/env ruby

require 'httparty'
require 'nokogiri'

class Container
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

    def initialize(url)
		url = HTTParty.get(url)
        # only replace if null
		@parser ||= Nokogiri::HTML(url)
    end
    
    def parse_tags(tags)
        arr = tags.split(" ")
        result = parser.css(arr[0])
        arr.each do|a|
            result = result.css(a)
        end
        return result
    end
end

puts ARGV[0]

#Define container to search through
elements = []
attempts = 0
while elements.empty?
    attempts += 1
    if attempts > 20
        puts "Scraping failed - check arguments or try again"
        break
    end
    elements = Container.new(ARGV[0]).parse_tags(ARGV[1]).children.map { |elements| elements.text }.compact
end
    

# loop from 0 to events size
(0...elements.size).each do |index|
	puts "\n===== Instance: #{index+1} ====="
	puts "#{elements[index]}"
end

