def eq_indices(list)
  list.each_index.select do |i|
    list[0...i].sum == list[i+1..-1].sum
  end
end
