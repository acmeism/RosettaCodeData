def sum_3_5_multiples(n)
  (0...n).select { |i| i % 3 == 0 || i % 5 == 0 }.sum
end

puts sum_3_5_multiples(1000)
