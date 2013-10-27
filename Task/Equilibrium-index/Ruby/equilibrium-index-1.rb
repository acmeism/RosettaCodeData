def eq_indices(list)
  list.each_index.select do |i|
    list[0...i].inject(0, :+) == list[i+1..-1].inject(0, :+)
  end
end
