#!/usr/bin/ruby
# Script for opening tmux session with standard windows

def shell_out_and_exit cmd
  system "#{cmd}"
  exit 0
end

def create_standard_tmux_session session_name
  commands = [
	  "tmux new -d                   -s #{session_name} -n emacs",
	  "tmux new-window -n 'vim'      -t #{session_name}",
	  "tmux new-window -n 'services' -t #{session_name}",
	  "tmux new-window -n 'git'      -t #{session_name}",
	  "tmux new-window -n 'repl'     -t #{session_name}",
	  "tmux new-window -n 'remote'   -t #{session_name}",
	  "tmux new-window -n 'dbshell'  -t #{session_name}",
	  "tmux new-window -n 'tests'    -t #{session_name}",
	  "tmux new-window -n 'misc'     -t #{session_name}",
		"tmux select-window            -t #{session_name}:0",
	  "tmux -2 attach-session        -t #{session_name}"
	]
	commands.each do |cmd|
		system cmd
	end
end

def output_current_tmux_sessions
	current_sessions = `tmux list-sessions | cut -f1 -d:`.split("\n")
	# List all the current sessions
	puts "Found the following sessions:"
	current_sessions.each do |session|
		puts "  #{session}"
	end
	current_sessions
end

def pull_off_working_directory
	working_dir = `pwd`
	working_dir = working_dir[0..working_dir.length-2].split("\/").last
	working_dir
end

def create_new_session session_name
	new_session_flag = ''
	while new_session_flag != 'y' or new_session_flag != 'n'
		print "Create new tmux session #{session_name}? (y/n) > "
		new_session_flag = STDIN.gets.chomp
		if new_session_flag == 'y' then
			create_standard_tmux_session session_name
			exit 0
		elsif new_session_flag == 'n' then
			puts "exiting..."
			exit 0
		end
	end
end

new_session = ARGV.first
# List sessions
if new_session == 'list' then
  output_current_tmux_sessions
  exit 0
end

# Kill specified session
if new_session == 'kill'
  session_to_kill = ARGV[1]
  if not session_to_kill.nil?
    shell_out_and_exit "tmux kill-session -t #{session_to_kill}"
  end
end

# Create new session with the name of the current directory
if new_session == '--here' then
	new_session = pull_off_working_directory
end
if new_session == nil then
	puts "error: must enter a session name"
	exit 1

else

	sessions_exist = system "tmux list-sessions > /dev/null 2>&1"
	if sessions_exist then
		current_sessions = output_current_tmux_sessions
		current_sessions.each do |session|
			if session == new_session then
				# Found a session with the same name, prompt to either join the session or exit.
				join = ''
				while join != 'y' or join != 'n'
					print "Found session #{session}, join? (y/n) > "
					join = STDIN.gets.chomp
					if join == 'y' then
						system "tmux attach -t #{session}"
						exit 0
					elsif join == 'n' then
						puts "exiting..."
						exit 0
					end
				end
			end
		end

		# Create a new session
		create_new_session new_session
	end

	create_new_session new_session
end
