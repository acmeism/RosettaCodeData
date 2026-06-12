a = (2..5).to_a
p a.product(a).map{_1 ** _2}.sort.uniq
