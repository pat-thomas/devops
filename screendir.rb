#!/usr/bin/env ruby
full_path = Dir.pwd
full_path = full_path.split("/")
system "screen -S #{full_path[full_path.length-1]}"
