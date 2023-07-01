def eq_indices(list)
  left, right = 0, list.sum
  equilibrium_indices = []

  list.each_with_index do |val, i|
    right -= val
    equilibrium_indices << i if right == left
    left += val
  end

  equilibrium_indices
end
