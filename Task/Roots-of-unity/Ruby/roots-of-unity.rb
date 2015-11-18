for n in 2..10
  printf "%2d: ", n
  puts (0...n).map { |k| "%8.5f %+8.5fi" % Complex.polar(1, 2 * Math::PI * k / n).rect }.join(", ")
end
