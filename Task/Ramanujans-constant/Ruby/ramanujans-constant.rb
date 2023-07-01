require "bigdecimal/math"
include BigMath

e, pi = E(200), PI(200)
[19, 43, 67, 163].each do |x|
  puts "#{x}: #{(e ** (pi * BigMath.sqrt(BigDecimal(x), 200))).round(100).to_s("F")}"
end
