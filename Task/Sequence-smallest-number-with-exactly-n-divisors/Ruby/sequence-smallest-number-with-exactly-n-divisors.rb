require 'prime'

def num_divisors(n)
  n.prime_division.inject(1){|prod, (_p,n)| prod *= (n + 1) }
end

def first_with_num_divs(n)
  (1..).detect{|i| num_divisors(i) == n }
end

p (1..15).map{|n| first_with_num_divs(n) }
