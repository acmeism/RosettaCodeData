class Array
  def counting_sort!
    replace counting_sort
  end

  def counting_sort
    min, max = minmax
    count = Array.new(max - min + 1, 0)
    each {|number| count[number - min] += 1}
    (min..max).each_with_object([]) {|i, ary| ary.concat([i] * count[i - min])}
  end
end

ary = [9,7,10,2,9,7,4,3,10,2,7,10,2,1,3,8,7,3,9,5,8,5,1,6,3,7,5,4,6,9,9,6,6,10,2,4,5,2,8,2,2,5,2,9,3,3,5,7,8,4]
p ary.counting_sort.join(",")
# => "1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,5,5,5,5,5,5,6,6,6,6,7,7,7,7,7,7,8,8,8,8,9,9,9,9,9,9,10,10,10,10"

p ary = Array.new(20){rand(-10..10)}
# => [-3, -1, 9, -6, -8, -3, 5, -7, 4, 0, 5, 0, 2, -2, -6, 10, -10, -7, 5, -7]
p ary.counting_sort
# => [-10, -8, -7, -7, -7, -6, -6, -3, -3, -2, -1, 0, 0, 2, 4, 5, 5, 5, 9, 10]
