def two_sum(numbers, sum)
  numbers.each_with_index do |x,i|
    key = sum - x
    if j = numbers.bsearch_index{|y| key<=>y}
      return [i,j]
    end
  end
  []
end
