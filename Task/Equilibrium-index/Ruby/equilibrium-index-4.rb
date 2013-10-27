indices = [
  [-7, 1, 5, 2,-4, 3, 0],
  [2, 4, 6],
  [2, 9, 2],
  [1,-1, 1,-1, 1,-1, 1]
]
indices.each do |x|
  puts "%p => %p" % [x, eq_indices(x)]
end
