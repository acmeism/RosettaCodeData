def eq_indicies *list
  len = list.size

  (0...len).select do |i|
    list[0, i].inject(0, &:+) == list[i + 1, len - i - 1].inject(0, &:+)
  end
end
