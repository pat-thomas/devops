#!/usr/bin/env ruby
# ffn = 'find file name'

require 'trollop'

opts = Trollop::options do
  opt :recursive, "Search directories recursively"
end

if ARGV.length != 1
	puts 'Error: Must enter a file name to search for.'
	puts 'Example: ffn rakefile'
	exit 1
end

def glob opts
  if opts[:recursive] then
    "**/*"
  else
    "**"
  end
end

chunk = ARGV[0].downcase

Dir[glob(opts)].each do |x|
  if x.downcase.include?(chunk)
    puts x
  end
end
