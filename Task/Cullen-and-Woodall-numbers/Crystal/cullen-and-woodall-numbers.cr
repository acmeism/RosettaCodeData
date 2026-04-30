require "big"

def cullen_numbers
  (1..).each.map {|n| (2.to_big_i ** n) * n + 1 }
end

def woodall_numbers
  (1..).each.map {|n| (2.to_big_i ** n) * n - 1 }
end

puts cullen_numbers.first(20).to_a
puts woodall_numbers.first(20).to_a
