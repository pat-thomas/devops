require "colorize"

def alternate_colors strings
  strings.map.with_index { |s,i|
    if i.even? then
      "[#{i}] #{s}".blue
    else
      "[#{i}] #{s}".red
    end
  }
end
