(1..5000).select { |n| n == n.asDigits.sum { |x| pow(x, x) } }
