(1..6).each do |n|
  puzzle = Queen.new(n)
  puts " #{n} Queen : #{puzzle.solve}"
end

(7..12).each do |n|
  puzzle = Queen.new(n)
  puts " #{n} Queen : #{puzzle.solve(false)}"   # no display
end
