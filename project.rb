#!/usr/bin/ruby
# Script for cd'ing into a project in your standard projects directory.

require "json"

def load_config
  @config = JSON.parse(File.read("#{ENV['HOME']}/config.json"))
end

def main
  load_config
  if !@config
    exit 1
  end
  project_dir = ARGV[0]
  path = "#{ENV['HOME']}/#{@config['projects_root']}/#{project_dir}"
  puts "cd #{path}"
end

main
