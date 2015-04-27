#!/usr/bin/env ruby
require "rubygems"
require "rspec"
require "trollop"

def load_config
  if File.exist?("./.main_feature_branch")
    @main_feature_branch = File.read("./.main_feature_branch")
  end
end

def rspec_command_for_feature_branch feature_branch
  "rspec . --tag branch:#{feature_branch}"
end

def run_tests_for_file opts
  if !opts[:branch]
    puts "No feature branch provided, running only tests tagged for main branch: #{@main_feature_branch}"
    cmd = "rspec #{opts[:filename]}"
    return system cmd
  end

  puts "Running tests for feature branch: #{opts[:branch]}"
  cmd = "rspec #{opts[:filename]} --tag branch:#{opts[:branch]}"
  system cmd
end

def main
  opts = Trollop::options do
    opt :branch,   "Feature branch to run tests for", :type => :string
    opt :filename, "Filename to run tests for",       :type => :string
  end
  load_config

  if opts[:filename]
    run_tests_for_file opts
    return
  end

  if !opts[:branch]
    if @main_feature_branch
      puts "No feature branch provided, running only tests tagged for main branch: #{@main_feature_branch}"
    else
      puts "No feature branch provided, running all tests"
    end
    return
  end

  puts "Running tests for feature branch: #{opts[:branch]}"
  cmd = "rspec . --tag branch:#{opts[:branch]}"
  system cmd
end

main
