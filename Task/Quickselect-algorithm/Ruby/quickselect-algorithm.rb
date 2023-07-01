def quickselect(a, k)
  arr = a.dup # we will be modifying it
  loop do
    pivot = arr.delete_at(rand(arr.length))
    left, right = arr.partition { |x| x < pivot }
    if k == left.length
      return pivot
    elsif k < left.length
      arr = left
    else
      k = k - left.length - 1
      arr = right
    end
  end
end

v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
p v.each_index.map { |i| quickselect(v, i) }
