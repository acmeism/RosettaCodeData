def digsum n
  n.to_s.chars.map(&:to_i).reduce(:+)
end

harshad = 1.step.lazy.select { |n| n % digsum(n) == 0 }
#harshad = (1..Float::INFINITY).lazy.select { |n| n % digsum(n) == 0 }  # ver 2.0

p harshad.first(20)
p harshad.find { |n| n > 1000 }
