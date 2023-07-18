require 'prime'
def num_divisors(n)
  n.prime_division.inject(1){|prod, (_p,n)| prod * (n + 1) }
end

anti_primes = Enumerator.new do |y| # y is the yielder
  max = 0
  y << 1                            # yield 1
  2.step(nil,2) do |candidate|      # nil is taken as Infinity
     num = num_divisors(candidate)
     if  num > max
       y << candidate               # yield the candidate
       max = num
     end
  end
end

puts anti_primes.take(20).join(" ")
