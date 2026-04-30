def evolve (s, rule)
  rule = (rule.is_a?(Int) ? ("%08b" % rule).reverse : rule).chars
  cells = ['0'].concat(s.chars) << '0'
  Array(Char).new(cells.size - 2) {|i|
    rule[cells[i..i+2].join.to_i(2)]
  }.join
end

[{"Task rule", "00010110", "01110110101010100100"},
 {"Rule 90 (from Raku)", 90, "000000000000000010000000000000000"}].each do |title, rule, start|
  gen = start
  puts "#{title} - first 15 generations or until stable:"
  15.times do
    puts gen.gsub(/./, { "0" => " ", "1" => "#" })
    next_gen = evolve(gen, rule)
    break if next_gen == gen
    gen = next_gen
  end
end
