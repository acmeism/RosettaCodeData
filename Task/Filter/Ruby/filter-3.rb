ary = [1, 2, 3, 4, 5, 6]
ary.select!(&:even?)
p ary # => [2, 4, 6]
