harshad = 1.step.select { |n| n % n.to_s.chars.sum(&.to_i) == 0 }

puts "The first 20 harshard numbers are: \n#{ harshad.first(20).to_a }"
puts "The first harshard number > 1000 is #{ harshad.find { |n| n > 1000 } }"
