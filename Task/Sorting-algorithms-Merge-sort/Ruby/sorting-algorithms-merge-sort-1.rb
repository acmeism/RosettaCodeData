def merge_sort(m)
  return m if m.length <= 1

  middle = m.length / 2
  left = merge_sort(m[0...middle])
  right = merge_sort(m[middle..-1])
  merge(left, right)
end

def merge(left, right)
  result = []
  until left.empty? || right.empty?
    result << (left.first<=right.first ? left.shift : right.shift)
  end
  result + left + right
end

ary = [7,6,5,9,8,4,3,1,2,0]
p merge_sort(ary)                  # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
