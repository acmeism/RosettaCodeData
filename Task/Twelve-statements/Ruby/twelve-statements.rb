constraints = [
  ->(st) { st.size == 12 },
  ->(st) { st.last(6).count(true) == 3 },
  ->(st) { st.each_slice(2).map(&:last).count(true) == 2 },
  ->(st) { st[4] ? (st[5] & st[6]) : true },
  ->(st) { st[1..3].none? },
  ->(st) { st.each_slice(2).map(&:first).count(true) == 4 },
  ->(st) { st[1] ^ st[2] },
  ->(st) { st[6] ? (st[4] & st[5]) : true  },
  ->(st) { st.first(6).count(true) == 3 },
  ->(st) { st[10] & st[11] },
  ->(st) { st[6..8].one? },
  ->(st) { st[0,11].count(true) == 4 },
]

Result = Struct.new(:truths, :consistency)

results = [true, false].repeated_permutation(12).map do |truths|
  Result.new(truths, constraints.zip(truths).map {|cn,truth| cn[truths] == truth })
end

puts "solution:",
  results.find {|r| r.consistency.all? }.truths.to_s

puts "\nnear misses: "
near_misses = results.select {|r| r.consistency.count(false) == 1 }
near_misses.each do |r|
  puts "missed by statement #{r.consistency.index(false) + 1}", r.truths.to_s
end
