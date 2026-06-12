def two_sum(numbers, sum)
  numbers.each_with_index do |x,i|
    if j = numbers.index(sum - x) then return [i,j] end
  end
  []
end

numbers = [0, 2, 11, 19, 90]
p two_sum(numbers, 21)
p two_sum(numbers, 25)
