(0..10).each do |s|
  puts "%s maps to %s" % [s, map_range(0..10, -1..0, s)]
end
