def eq_indicies *list
  final = list.size - 1
  result = []
  list.empty? and return result

  helper = lambda do |left, current, right, index|
    left == right and result << index   # Push index to result?
    index == final and return           # Terminate recursion?
    new = list[index + 1]
    helper.call(left + current, new, right - new, index + 1)
  end
  helper.call 0, list.first, list.inject(&:+) - list.first, 0
  return result
end
