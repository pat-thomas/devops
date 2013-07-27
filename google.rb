#!/usr/bin/env ruby
url_param = ARGV.join(' ')
output = `uname -a`
output.downcase!
if output.include?('linux') then
	system "google-chrome \"http://www.google.com/search?q=#{url_param}\""
	puts "googling #{url_param}"
	exit 0
end
puts "googling #{url_param}"
system "open \"http://www.google.com/search?q=#{url_param}\""
