require "big"

def rump(a, b)
  a, b = a.to_big_r, b.to_big_r
  333.75.to_big_r * b**6 + a**2 * (11 * a**2 * b**2 - b**6 - 121 * b**4 - 2) + 5.5.to_big_r * b**8 + a / (2 * b)
end

puts "rump(77617, 33096) = #{rump(77617, 33096).to_f}"
