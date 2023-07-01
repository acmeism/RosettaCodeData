(1..6).each do |n|
  puzzle = Queen.new(n)
  puts " #{n} Queen : #{puzzle.count}"
end

(7..12).each do |n|
  puzzle = Queen.new(n, false)                # do not display
  puts " #{n} Queen : #{puzzle.count}"
end
