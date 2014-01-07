#!/usr/bin/ruby
# Script for opening tmux session with standard windows

require "colorize"
require "pathname"

APP_ROOT = Pathname.new(__FILE__).realpath + "../helpers"
require "#{APP_ROOT}"

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
    puts "{#{(alternate_colors current_tmux_sessions).join(',')}}"
  else
    puts "{#{(alternate_colors (grep_for_sessions sessions_to_grep_for)).join(',')}}"
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

def create_or_join_session session_name
  if session_name == '--here' then
    session_name = pull_off_working_directory
  end
  existing_session_joined = attempt_to_join_existing_session session_name
  if not existing_session_joined then
    new_session_flag = ""
    while new_session_flag != 'y' or new_session_flag != 'n'
      print "Create new tmux session #{session_name}? (y/n) > ".blue
      new_session_flag = STDIN.gets.chomp
      if new_session_flag == 'y' then
        create_standard_tmux_session session_name
        exit 0
      elsif new_session_flag == 'n' then
        exit 0
      end
    end
  end
end # create_or_join_session

def attempt_to_join_existing_session session_name
  current_tmux_sessions.each do |name|
    if name == session_name then
      system "tmux attach -t #{session_name}"
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
  case ARGV[0]
  when "list"
    list_sessions ARGV[1..-1]
  when "kill"
    kill_sessions ARGV[1..-1]
  else
    create_or_join_session ARGV[0]
  end
end

main
