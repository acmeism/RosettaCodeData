possible_doughnuts = ['iced', 'jam', 'plain'].repeated_combination(2)
puts "There are #{possible_doughnuts.count} possible doughnuts:"
possible_doughnuts.each{|doughnut_combi| puts doughnut_combi.join(' and ')}

# Extra credit
possible_doughnuts = [*1..10].repeated_combination(3)
# size returns the size of the enumerator, or nil if it can’t be calculated lazily.
puts "", "#{possible_doughnuts.size} ways to order 3 donuts given 10 types."
