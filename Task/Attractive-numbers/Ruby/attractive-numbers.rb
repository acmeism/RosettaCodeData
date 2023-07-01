require "prime"

p (1..120).select{|n| n.prime_division.sum(&:last).prime? }
