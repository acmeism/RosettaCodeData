def subarray_sum(arr)
  max, slice = 0, []
  arr.each_index do |i|
    (i...arr.length).each do |j|
      sum = arr[i..j].inject(0, :+)
      max, slice = sum, arr[i..j]  if sum > max
    end
  end
  [max, slice]
end
