require "colorize"

def alternate_colors strings
  strings.map.with_index { |s,i|
    if i.even? then
      s.blue
    else
      s.red
    end
  }
end
