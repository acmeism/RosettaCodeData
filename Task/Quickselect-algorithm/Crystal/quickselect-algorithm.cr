def quickselect(a, k)
  arr = a.dup # we will be modifying it
  loop do
    pivot = arr.delete_at(rand(arr.size))
    left, right = arr.partition { |x| x < pivot }
    if k == left.size
      return pivot
    elsif k < left.size
      arr = left
    else
      k = k - left.size - 1
      arr = right
    end
  end
end

v = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
p v.each_index.map { |i| quickselect(v, i) }.to_a
