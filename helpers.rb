require "colorize"

def alternate_colors strings
  strings.map.with_index { |s,i|
    if i.even? then
      "[#{i+1}] #{s}".blue
    else
      "[#{i+1}] #{s}".red
    end
  }
end
