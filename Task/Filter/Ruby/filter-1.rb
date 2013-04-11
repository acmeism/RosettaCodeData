# Enumerable#select returns a new array.
ary = [1, 2, 3, 4, 5, 6]
even_ary = ary.select {|elem| elem.even?}
p even_ary # => [2, 4, 6]

# Enumerable#select also works with Range.
range = 1..6
even_ary = range.select {|elem| elem.even?}
p even_ary # => [2, 4, 6]
