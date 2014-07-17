#!/usr/bin/ruby
# Script for opening tmux session with standard windows

require "colorize"
require "pathname"
require "json"

APP_ROOT = Pathname.new(__FILE__).realpath + "../helpers"
require "#{APP_ROOT}"

def load_config
  @config = JSON.parse(File.read("#{ENV['HOME']}/config.json"))
end

def create_standard_tmux_session session_name
  commands = [
	  "tmux new -d                         -s #{session_name} -n emacs",
	  "tmux new-window -n 'vim'            -t #{session_name}",
	  "tmux new-window -n 'services'       -t #{session_name}",
	  "tmux new-window -n 'build-services' -t #{session_name}",
	  "tmux new-window -n 'git'            -t #{session_name}",
	  "tmux new-window -n 'repl'           -t #{session_name}",
	  "tmux new-window -n 'remote'         -t #{session_name}",
	  "tmux new-window -n 'dbshell'        -t #{session_name}",
	  "tmux new-window -n 'tests'          -t #{session_name}",
	  "tmux new-window -n 'misc'           -t #{session_name}",
    "tmux select-window                  -t #{session_name}:4", # Chances are you want to select the 'git' window on startup
                                                                # to pull recent changes. If not, just choose a different number.
	  "tmux attach-session                 -t #{session_name}"
	]
	commands.each do |cmd|
		system cmd
	end
end # create_standard_tmux_session

def current_tmux_sessions
	current_sessions = `tmux list-sessions | cut -f1 -d:`.split("\n")
  current_sessions
end # current_tmux_sessions

def pull_off_working_directory
	working_dir = `pwd`
	working_dir = working_dir[0..working_dir.length-2].split("\/").last
	working_dir
end # pull_off_working_directory

def list_sessions sessions_to_grep_for
  if sessions_to_grep_for.empty?
    (alternate_colors current_tmux_sessions).each do |name|
      puts name
    end
  else
    (alternate_colors (grep_for_sessions sessions_to_grep_for)).each do |name|
      puts name
    end
  end
end # list_sessions

def grep_for_sessions sessions_to_grep_for
  accum = []
  (sessions_to_grep_for.map { |s| s.downcase }).each do |session|
    current_tmux_sessions.each do |current_session|
      if current_session.downcase.include? session then
        accum.push current_session
      end
    end
  end
  accum
end # grep_for_sessions

def session_is_in_projects_directory session_name
  found_session = false
  if !@config
    return false
  end
  Dir.entries("#{ENV['HOME']}/#{@config['projects_root']}").each do |dir|
    if dir == session_name
      found_session = true
    else
      false
    end
  end
  found_session
end

def suggest_sessions_from_project_directory
  
  output = Dir.entries("#{ENV['HOME']}/#{@config['projects_root']}").reject do |dir|
    dir == '.' or dir == '..'
  end.join(", ")

  puts "Error: must provide a session name."
  puts "Try one of these projects... #{output}"
  exit 0
end

def prompt_for_new_session session_name
  if session_name.nil?
    suggest_sessions_from_project_directory
  end
  new_session_flag = ""
  while new_session_flag != 'y' or new_session_flag != 'n'
    output_one       = "Create new tmux session".blue
    red_session_name = (session_name.dup).red
    output_two       = "? (y/n) >".blue
    print output_one + " " + red_session_name + output_two + " "
    new_session_flag = STDIN.gets.chomp
    if new_session_flag == 'y' then
      create_standard_tmux_session session_name
      exit 0
    elsif new_session_flag == 'n' then
      exit 0
    end
  end
end

def create_or_join_session session_name
  if session_name == '--here' then
    session_name = pull_off_working_directory
  end
  existing_session_joined = attempt_to_join_existing_session session_name
  if (!existing_session_joined && (session_is_in_projects_directory session_name))
    Dir.chdir "#{ENV['HOME']}/#{@config['projects_root']}/#{session_name}"
    prompt_for_new_session session_name
  end
  if session_name.to_i > current_tmux_sessions.length
    exit 0
  end
  if not existing_session_joined then
    prompt_for_new_session session_name
  end
end # create_or_join_session

def attempt_to_join_existing_session session_name
  if session_name.to_i == 0 then
    current_tmux_sessions.each do |name|
      if name == session_name then
        system "tmux attach -t #{session_name}"
        return true
      end
    end
  else
    index = session_name.to_i
    if current_tmux_sessions.length < index then
      return false
    else
      system "tmux attach -t #{current_tmux_sessions[index-1]}"
      return true
    end
  end
  return false
end # attempt_to_join_existing_session

def kill_sessions session_names
  session_names.each do |session|
    system "tmux kill-session -t #{session}"
  end
end # kill_sessions

def main
  load_config
  case ARGV[0]
  when "list"
    list_sessions ARGV[1..-1]
  when "suicide"
    kill_sessions [pull_off_working_directory]
  when "kill"
    kill_sessions ARGV[1..-1]
  else
    create_or_join_session ARGV[0]
  end
end

main
