# hsfreq.rb
require 'hailstone'

h = Hash.new(0)
last = 99_999
(1..last).each {|n| h[Hailstone.hailstone(n).length] += 1}
length, count = h.max_by {|length, count| count}

puts "Given the hailstone sequences from 1 to #{last},"
puts "the most common sequence length is #{length},"
puts "with #{count} such sequences."
