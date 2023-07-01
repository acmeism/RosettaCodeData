def subarray_sum(arr)
  max, slice = 0, [] of Int32
  arr.each_index do |i|
    (i...arr.size).each do |j|
      sum = arr[i..j].sum
      max, slice = sum, arr[i..j] if sum > max
    end
  end
  [max, slice]
end
