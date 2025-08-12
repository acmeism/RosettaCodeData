from = ['A'..'Z', 'a'..'z'].flat_map(&.to_a).join
to   = ['N'..'Z', 'A'..'M', 'n'..'z', 'a'..'m'].flat_map(&.to_a).join
while line = ARGF.gets
  puts line.tr from, to
end
