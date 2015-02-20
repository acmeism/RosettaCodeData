def merge_sort(m)
  return m if m.length <= 1

  middle = m.length / 2
  left = m[0..middle - 1]
  right = m[middle..-1]

  left = merge_sort(left)
  right = merge_sort(right)
  merge(left, right)
end

def merge(left, right)
  result = []
  until left.empty? || right.empty?
    if left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end
  result + left + right
end

ary = [7,6,5,9,8,4,3,1,2,0]
p merge_sort(ary)                  # => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
