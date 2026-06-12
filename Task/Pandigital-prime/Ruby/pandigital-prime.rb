require "prime"

def find_pan(ar) = ar.permutation(ar.size).find{|perm| perm.join.to_i.prime? }.join.to_i

digits = [7,6,5,4,3,2,1]
puts find_pan(digits)
digits << 0
puts find_pan(digits)
