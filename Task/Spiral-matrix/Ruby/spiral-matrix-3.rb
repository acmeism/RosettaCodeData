def spiral_matrix(n)
  x, y, dx, dy = -1, 0, 0, -1
  fmt = "%#{(n*n-1).to_s.size}d " * n
  n.downto(1).flat_map{|x| [x, x-1]}.flat_map{|run|
    dx, dy = -dy, dx                    # turn 90
    run.times.map { [y+=dy, x+=dx] }
  }.each_with_index.sort.map(&:last).each_slice(n){|row| puts fmt % row}
end

spiral_matrix(5)
