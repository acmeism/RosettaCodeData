require 'prime'

taus = Enumerator.new do |y|
  (1..).each do |n|
    num_divisors = n.prime_division.inject(1){|prod, n| prod *= n[1] + 1 }
    y << n if n % num_divisors == 0
  end
end

p taus.take(100)
