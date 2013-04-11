n = 20

unless Enumerable.method_defined? :flat_map
  module Enumerable
    def flat_map
      inject([]) { |a, x| a.concat yield(x) }
    end
  end
end

unless Array.method_defined? :keep_if
  class Array
    def keep_if
      delete_if { |x| not yield(x) }
    end
  end
end

# select Pythagorean triplets
r = ((1..n).flat_map { |x|
       (x..n).flat_map { |y|
         (y..n).flat_map { |z|
           [[x, y, z]].keep_if { x * x + y * y == z * z }}}})

p r # print the array _r_
