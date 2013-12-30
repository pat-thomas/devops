# Find File: finds a file and copies its name to the clipboard. Prompts user if more than one file was found.

def on_os name
  os_kernel = `uname -a`
  os_kernel.downcase.include?(name)
end

def git_grep_files pattern
  `git grep -l #{pattern}`.split("\n")
end

found_files = git_grep_files(ARGV.first)

if (found_files.length == 1) then
  system "copying #{found_files[0]} to clipboard"

  if on_os "mac" then
    system "echo #{found_files[0]} | pbcopy"
  elsif on_os "linux" then
    system "echo #{found_files[0]} | xclip"
  else
    puts "error: operating system not recognized"
  end
  exit 0
end

found_files.each do |file|
  puts "found #{file}"
end
