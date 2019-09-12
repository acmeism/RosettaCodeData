harshad = 1.step.lazy.select { |n| n % n.digits.sum == 0 }

puts "The first 20 harshard numbers are: \n#{ harshad.first(20) }"
puts "The first harshard number > 1000 is #{ harshad.find { |n| n > 1000 } }"
