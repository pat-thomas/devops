# This is a one-off script that should be run to install (or update)
# the various scripts in this directory. It will symbolically link
# all the scripts in this directory to ~/usr/bin.
working_dir = `pwd`
rb_file_string = `ls *.rb`
rb_files = rb_file_string.split( /\r?\n/ )
rb_files.keep_if { |fname| fname != "install.rb" }
rb_files.each do |filename|
	if File.exist?("/home/#{`logname`[0..-2]}/bin/#{filename[0..-4]}") then
		puts "Found existing symbolic link to #{filename}. Delete link and rerun this script if you are sure."
	else 
		puts "Linking #{filename} to ~/bin/#{filename[0..-4]}"
		system "ln -s `pwd`/#{filename} ~/bin/#{filename[0..-4]}"
	end
end
puts "All scripts were successfully linked."
exit 0
