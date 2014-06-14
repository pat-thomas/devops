#!/usr/bin/env ruby
# fbe = 'find by extension'

if ARGV.length != 1
  puts 'Error: Must enter a file extension to search for.'
  puts 'Example: fbe clj'
  exit
end

extension = ARGV[0]

Dir['**/*'].each do |x|
  if x.end_with? ".#{extension}"
    puts x
  end
end
