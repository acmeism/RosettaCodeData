def map_range (s, from, to)
  a1, a2 = from.begin, from.end
  b1, b2 = to.begin, to.end

  b1 + ( (s - a1) * (b2 - b1) ) / (a2 - a1)
end

(0..10).each do |i|
  printf " %2d -> %g\n", i, map_range(i, 0..10, -1..0)
end
