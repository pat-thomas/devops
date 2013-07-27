#!/usr/bin/ruby
# Script for opening tmux session with standard windows

def create_standard_tmux_session session_name
	commands = [
	 "tmux new -d                   -s #{session-name} 'emacs'",
	 "tmux new-window -n 'vim'      -t #{session_name}",
	 "tmux new-window -n 'services' -t #{session_name}",
	 "tmux new-window -n 'git'      -t #{session_name}",
	 "tmux new-window -n 'repl'     -t #{session_name}",
	 "tmux new-window -n 'remote'   -t #{session_name}",
	 "tmux new-window -n 'dbshell'  -t #{session_name}",
	 "tmux new-window -n 'tests'    -t #{session_name}",
	 "tmux new-window -n 'misc'     -t #{session_name}"
	]
	commands.each do |cmd|
		system cmd
	end
end

new_session = ARGV.first

sessions_exist = system "tmux list-sessions 1>&2> /dev/null"
if sessions_exist then
	current_sessions = `tmux list-sessions | cut -f1 -d:`.split("\n")
		# List all the current sessions
		puts "Found the following sessions:"
		current_sessions.each do |session|
			puts "  #{session}"
		end

		current_sessions.each do |session|
			if session == ARGV.first then
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
		create_new_session = ''
		while create_new_session != 'y' or create_new_session != 'n'
			print "Create new session #{new_session}? (y/n) > "
			create_new_session = STDIN.gets.chomp
			if create_new_session == 'y' then
				create_standard_tmux_session new_session
				exit 0
			elsif create_new_session == 'n' then
				puts "exiting..."
				exit 0
			end
		end
end
