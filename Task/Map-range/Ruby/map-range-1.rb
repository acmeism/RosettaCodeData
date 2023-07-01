def map_range(a, b, s)
  af, al, bf, bl = a.first, a.last, b.first, b.last
  bf + (s - af)*(bl - bf).quo(al - af)
end

(0..10).each{|s| puts "%s maps to %g" % [s, map_range(0..10, -1..0, s)]}
