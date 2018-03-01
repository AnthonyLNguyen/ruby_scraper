#!/bin/ruby

require 'httparty'
require 'nokogiri'
require 'openssl'

class Page
    def initialize(url)
        @url = url
    end
end

class Container
    attr_accessor :parser

    def initialize(outer)
		page = HTTParty.get("http://www.cpp.edu/events/")
		@parser ||= Nokogiri::HTML(page)
        @outer = parser.css(outer)
        @inners = []
    end
    def add_inner(inner)
        @inners << inner
    end
    def get_next(inner)
        @outer.css(inner)
    end
    def get_element(index)
        parse_tags(ARGV[index])
    end
    def parse_tags(tag)
        result = @outer
        arr = tag.split(" ")
        arr.each do|a|
            result = result.css(a)
        end
        return result
    end
end

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
        outer = Container.new(".event-intro")
        elements = outer.get_element(0).children.map { |elements| elements.text }.compact
        (1...ARGV.size).each do |index|
            elements = outer.get_element(index).children.map { |elements| elements+"\n"+elements.text }.compact
        end
        return elements
    end
    sc = Scraper.new
    elements = sc.container

	# loop from 0 to events size
	(0...elements.size).each do |index|
		puts "\n===== Element: #{index+1} ====="
		puts "#{elements[index]}"
	end
end

