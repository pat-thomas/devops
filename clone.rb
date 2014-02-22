#!/usr/bin/env ruby

if ARGV.length < 1
	puts 'Error: Must enter a repository to clone'
	exit
end

repo_user = ARGV[0]
repo_name = ARGV[1]
system "git clone git@github.com:#{repo_user}/#{repo_name}.git"
