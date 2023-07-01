require 'prime'

def num_divisors(n)
  n.prime_division.inject(1){|prod, (_p,n)| prod *= (n + 1) }
end

seq = Enumerator.new do |y|
  cur = 0
  (1..).each do |i|
    if num_divisors(i) == cur + 1 then
      y << i
      cur += 1
    end
  end
end

p seq.take(15)
