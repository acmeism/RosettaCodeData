def bernoulli
  row = 0
  last = [1]
  [last].each.chain Iterator.of {
    last = [1] + last.each_cons_pair.map(&.sum).to_a + [2**(row += 1)]
  }
end

puts bernoulli.first(15).join("\n")
