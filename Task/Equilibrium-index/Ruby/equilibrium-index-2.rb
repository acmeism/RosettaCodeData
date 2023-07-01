def eq_indices(list)
  result = []
  list.empty? and return result
  final = list.size - 1

  helper = lambda do |left, current, right, index|
    left == right and result << index   # Push index to result?
    index == final and return           # Terminate recursion?
    new = list[index + 1]
    helper.call(left + current, new, right - new, index + 1)
  end
  helper.call 0, list.first, list.drop(1).sum, 0
  result
end
