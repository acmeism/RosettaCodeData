require "big"

puts (0..65).map {|n| Math.isqrt n }.join(" ")

(1..73).step(by: 2).each do |n|
  print "isqrt(7**#{n}) = ", Math.isqrt(7.to_big_i ** n).format, "\n"
end
