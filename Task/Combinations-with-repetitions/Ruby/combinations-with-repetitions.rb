possible_doughnuts = ['iced', 'jam', 'plain'].repeated_combination(2)
puts "There are #{possible_doughnuts.count} possible doughnuts:"
possible_doughnuts.each{|doughnut_combi| puts doughnut_combi.join(' and ')}

# Extra credit
possible_doughnuts = [*1..1000].repeated_combination(30)
# size returns the size of the enumerator, or nil if it can’t be calculated lazily.
puts "", "#{possible_doughnuts.size} ways to order 30 donuts given 1000 types."
