def circle_from_3_points(z1, z2, z3) #args expected to be complex numbers
  raise ArgumentError, "Duplicate points: #{[z1, z2, z3]}" if [z1, z2, z3].uniq.count < 3
  w = (z3 - z1) / (z2 - z1)
  raise ArgumentError, "Points are collinear: #{[z1, z2, z3]}" if w.imag.abs <= 0
  c = (z2 - z1) * (w - w.abs**2) / (2i * w.imag) + z1
  r = (z1 - c).abs
  [c, r]
end

center, radius = circle_from_3_points(22.83+2.07i, 14.39+30.24i, 33.65+17.31i)
puts "centerpoint: #{center}", "radius: #{radius}"
