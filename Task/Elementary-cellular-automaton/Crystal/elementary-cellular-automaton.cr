def evolve (s, rule)
  rule = (rule.is_a?(Int) ? ("%08b" % rule).reverse : rule).chars
  cells = [s[-1]].concat(s.chars) << s[0]
  Array(Char).new(cells.size - 2) {|i|
    rule[cells[i..i+2].join.to_i(2)]
  }.join
end

puts "Rule 30, 10 generations:"
cells = "0" * 10 + "1" + "0" * 10
10.times do
  puts cells.tr("01", " #")
  cells = evolve(cells, 30)
end
