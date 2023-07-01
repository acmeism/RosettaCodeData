h = $stdin.group_by(&:size)
puts h.max.last  unless h.empty?
