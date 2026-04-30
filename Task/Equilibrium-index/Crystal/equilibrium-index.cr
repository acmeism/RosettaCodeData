def equilibrium_indices (arr)
  left = 0
  right = arr.sum
  indices = [] of Int32
  (0...arr.size).each do |i|
    right -= arr[i]
    indices << i if left == right
    left += arr[i]
  end
  indices
end

[[-7, 1, 5, 2, -4, 3, 0], [2, 4, 6], [2, 9, 2], [1,-1, 1,-1, 1,-1, 1]].each do |arr|
  print arr, ": ", equilibrium_indices(arr), "\n"
end
