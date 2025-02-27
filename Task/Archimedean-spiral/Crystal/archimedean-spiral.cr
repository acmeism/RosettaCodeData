# output utilities -- solution starts after them
def print_line (line)
  (0..line[0].size-1).step(2) do |i|
    char = ((line[0][i]        | line[1][i]   << 1 | line[2][i] << 2 |
             line[0][i+1] << 3 | line[1][i+1] << 4 | line[2][i+1] << 5 |
             line[3][i]   << 6 | line[3][i+1] << 7) + 0x2800).chr
    print char
  end
  puts
end

def print_dots (coords, screen_width)
  coords = coords.sort_by {|x, y| y}
  left, right = coords.map(&.first).minmax
  if screen_width.odd?
    screen_width -= 1
  end
  factor = screen_width / (right - left + 1)
  line = (0..3).map { Array(UInt32).new(screen_width, 0) }
  row = (coords[0].last * factor).to_i
  coords.map {|x, y| {((x - left) * factor).to_i, (y * factor).to_i} }.each do |x, y|
    while y > row+3
      print_line line
      line.each do |stripe| stripe.fill(0) end
      row += 4
    end
    line[y - row][x] = 1
  end
  print_line line
end

# actual solution starts here:

def spiral (a, b, step_resolution, step_count)
  start, stop = 0.0, step_count * step_resolution
  (start..stop).step(step_resolution).map { |theta|
    r = a + b * theta
    { r * Math.cos(theta), r * Math.sin(theta) }
  }.to_a
end

print_dots(spiral(10, 10, 0.01, 4000), 60)
