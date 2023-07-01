require 'set'

# different ways of creating a set
p s1 = Set[1, 2, 3, 4]          #=> #<Set: {1, 2, 3, 4}>
p s2 = [8, 6, 4, 2].to_set      #=> #<Set: {8, 6, 4, 2}>
p s3 = Set.new(1..4) {|x| x*2}  #=> #<Set: {2, 4, 6, 8}>

# Union
p s1 | s2                       #=> #<Set: {1, 2, 3, 4, 8, 6}>
# Intersection
p s1 & s2                       #=> #<Set: {4, 2}>
# Difference
p s1 - s2                       #=> #<Set: {1, 3}>

p s1 ^ s2                       #=> #<Set: {8, 6, 1, 3}>

p s2 == s3                      #=> true

p s1.add(5)                     #=> #<Set: {1, 2, 3, 4, 5}>
p s1 << 0                       #=> #<Set: {1, 2, 3, 4, 5, 0}>
p s1.delete(3)                  #=> #<Set: {1, 2, 4, 5, 0}>
