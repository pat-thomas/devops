#!/usr/bin/env ruby

if ARGV.length < 1
	puts 'Error: Must enter a repository to clone'
	exit
end

if ARGV.length == 1 # assume you want to clone my repo, because I'm awesome
  repo_user = "pat-thomas"
  repo_name = ARGV[0]
else
  repo_user = ARGV[0]
  repo_name = ARGV[1]
end

system "git clone git@github.com:#{repo_user}/#{repo_name}.git"
