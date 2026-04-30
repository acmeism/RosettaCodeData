examples = [
  [-2,  2,  1],
  [-2,  2,  0],
  [-2,  2, -1],
  [-2,  2, 10],
  [ 2, -2,  1],
  [ 2,  2,  1],
  [ 2,  2, -1],
  [ 2,  2,  0],
  [ 0,  0,  0]
]

examples.each do |(start, stop, step)|
  range = (start..stop).step(step) rescue nil
  size = range ? range.dup.size : "<not possible>"
  printf "from %2d to %2d by %2d, size: %s", start, stop, step, size
  print ", steps: ", range.first(10).join " " if range
  puts
end
