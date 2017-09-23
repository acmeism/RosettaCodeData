harshad = 1.step.lazy.select { |n| n % n.digits.sum == 0 }

p harshad.first(20)
p harshad.find { |n| n > 1000 }
