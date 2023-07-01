require 'prime'

n = 100
puts "The first #{n} Godbach numbers are: "
sums = Prime.each(n*2 + 2).to_a[1..].repeated_combination(2).map(&:sum)
sums << 4
sums.sort.tally.values[...n].each_slice(10){|slice| puts "%4d"*slice.size % slice}

n = 1000000
puts "\nThe value of G(#{n}) is #{Prime.each(n/2).count{|pr| (n-pr).prime?} }."
