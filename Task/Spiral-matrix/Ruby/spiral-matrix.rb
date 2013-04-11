def spiral(n)
  spiral = Array.new(n) {Array.new(n, nil)}     # n x n array of nils
  runs = n.downto(0).each_cons(2).to_a.flatten  # n==5; [5,4,4,3,3,2,2,1,1,0]
  delta = [[1,0], [0,1], [-1,0], [0,-1]].each
  x, y, value = -1, 0, -1
  for run in runs
    dx,dy = begin
              delta.next
            rescue StopIteration
              delta.rewind
              retry
            end
    run.times do |i|
      x += dx
      y += dy
      value += 1
      spiral[y][x] = value
    end
  end
  spiral
end

print_matrix spiral(5)
