n = 20

# select Pythagorean triplets
r = ((1..n).flat_map { |x|
       (x..n).flat_map { |y|
         (y..n).flat_map { |z|
           [[x, y, z]].keep_if { x * x + y * y == z * z }}}})

p r # print the array _r_
