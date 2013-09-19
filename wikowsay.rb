#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'

args = ARGV
args[0] = args[0].downcase.capitalize
args[1..-1].map! { |a| a.downcase }
url_param = args.join('_')
document = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/#{url_param}"))
paragraphs = document.xpath('//p')
system "cowsay '#{paragraphs[1].content}'"
