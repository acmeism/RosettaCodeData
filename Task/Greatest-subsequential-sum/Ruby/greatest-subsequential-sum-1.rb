Infinity = 1.0/0
def subarray_sum(arr)
  max, slice = -Infinity, []
  arr.each_with_index do |n, i|
    (i...arr.length).each do |j|
      sum = arr[i..j].inject(0) { |x, sum| sum += x }
      if sum > max
        max = sum
        slice = arr[i..j]
      end
    end
  end
  [max, slice]
end
