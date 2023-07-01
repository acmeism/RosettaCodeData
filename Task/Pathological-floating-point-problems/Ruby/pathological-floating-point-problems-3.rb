def rump(a,b)
  a, b = a.to_r, b.to_r
  333.75r * b**6 + a**2 * ( 11 * a**2 * b**2 - b**6 - 121 * b**4 - 2 )  + 5.5r *   b**8 + a / (2 * b)
end

puts "rump(77617, 33096) = #{rump(77617, 33096).to_f}"
