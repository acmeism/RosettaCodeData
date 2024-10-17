possible_doughnuts = ["iced", "jam", "plain"].repeated_combinations(2)
puts "There are #{possible_doughnuts.size} possible doughnuts:"
possible_doughnuts.each{|doughnut_combi| puts doughnut_combi.join(" and ")}

# Extra credit
possible_doughnuts = (1..10).to_a.repeated_combinations(3)
# size returns the size of the enumerator, or nil if it can’t be calculated lazily.
puts "", "#{possible_doughnuts.size} ways to order 3 donuts given 10 types."
