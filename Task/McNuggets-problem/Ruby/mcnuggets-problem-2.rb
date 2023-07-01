limit = 100
nugget_portions = [6, 9, 20]

arrs = nugget_portions.map{|n| 0.step(limit, n).to_a }
hits = arrs.pop.product(*arrs).map(&:sum)
p ((0..limit).to_a - hits).max # => 43
