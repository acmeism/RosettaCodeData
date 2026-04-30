def evolve (s, rule)
  rule = (rule.is_a?(Int) ? ("%08b" % rule).reverse : rule).chars
  cells = [s[-1]].concat(s.chars) << s[0]
  Array(Char).new(cells.size - 2) {|i|
    rule[cells[i..i+2].join.to_i(2)]
  }.join
end

cells = "1" + "0" * 100

p Iterator.of { curr = cells; cells = evolve(cells, 30); curr }
   .map(&.[0])
   .each_slice(8)
   .map(&.join.to_i(2))
   .first(10)
   .to_a
