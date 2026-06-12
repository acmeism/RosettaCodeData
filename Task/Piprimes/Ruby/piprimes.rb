require 'prime'

pi = 0
pies = (1..).lazy.map {|n| n.prime? ? pi += 1 : pi}.take_while{ pi < 22 }
pies.each_slice(10){|s| puts "%3d"*s.size % s}
