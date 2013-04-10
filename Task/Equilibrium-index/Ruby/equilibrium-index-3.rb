def eq_indicies *list
  left, right = 0, list.inject(0, &:+)
  equilibrium_indicies = []

  list.each_with_index do |val, i|
    right -= val

    equilibrium_indicies << i if right == left

    left += val
  end

  equilibrium_indicies
end
