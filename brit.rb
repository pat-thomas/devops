#!/usr/bin/env ruby
# working with Git and feature branches is hard/tedious, let's make it easier

require "pathname"
require "json"

APP_ROOT = Pathname.new(__FILE__).realpath + "../helpers"
require "#{APP_ROOT}"

def load_config
  @config = JSON.parse(File.read("#{ENV['HOME']}/config.json"))
  @git_branches_config = @config && @config["git"] && @config["git"]["main_branches"]
end

def lookup_main_branch project_name
  @git_branches_config[project_name] || "main"
end

def run_cmd_and_notify cmd
  puts "Running command: '#{cmd}'"
  puts "======================================================="
  system cmd
end

def rebase_main ctx
  cmds = [
    "git fetch",
    "git pull",
    "git rebase #{ctx[:main_branch]}"
  ]
  cmds.each do |cmd|
    run_cmd_and_notify cmd
  end
end

def respond_to_command cmd, ctx
  command_dispatch = {
    "rebase-main" => proc { |c| rebase_main c }
  }

  impl = command_dispatch[cmd]
  if !impl
    puts "Error: #{cmd} is not a valid command."
    puts "Supported commands are: #{command_dispatch.keys.sort.join(', ')}."
    exit 1
  end
  impl.call ctx
end

def main
  load_config
  current_directory_base = Dir.pwd.split("/").last
  main_branch            = lookup_main_branch current_directory_base
  cmd                    = ARGV[0]

  respond_to_command cmd, {:main_branch => main_branch}
end

main
