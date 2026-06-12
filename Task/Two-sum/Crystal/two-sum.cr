def n_sum (numbers, target, n = 2)
  (0...numbers.size).to_a.each_combination(n) do |set|
    return set if set.map {|idx| numbers[idx] }.sum == target
  end
  return [] of typeof(numbers[0])
end

arr = [0, 2, 11, 19, 90]

p! n_sum(arr, 21),
   n_sum(arr, 21, 3)
