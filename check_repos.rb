#!/usr/bin/ruby
require "open3"

@projects_root = "/Users/#{`whoami`}/projects".gsub("\n","")

def is_git_directory? dir
  git_status = Open3.popen3("git status") { |stdin, stdout, stderr, wait_thr| stdout.read() }
  !git_status.include? "fatal: Not a git repository (or any of the parent directories): .git"
end

def repo_is_dirty? dir
  git_status = Open3.popen3("git status") { |stdin, stdout, stderr, wait_thr| stdout.read() }.split("\n")
  git_status.keep_if { |line|
    line == "Changes not staged for commit:" or
    line == "Untracked files:"  or
    line == "Changes to be committed:"
  }.size > 0
end

def main
  accum = []
  Dir.entries(@projects_root).delete_if { |d| d == '.' or d == '..' }.each do |dir|
    full_path = "#{@projects_root}/#{dir}"
    Dir.chdir full_path do
      if is_git_directory? full_path and repo_is_dirty? dir
        accum.push(full_path)
        puts full_path
      end
    end
  end
end

main
