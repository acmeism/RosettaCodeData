require "prime"

class Integer
  def proper_divisors
    return [] if self == 1
    primes = prime_division.flat_map{|prime, freq| [prime] * freq}
    (1...primes.size).each_with_object([1]) do |n, res|
      primes.combination(n).map{|combi| res << combi.inject(:*)}
    end.flatten.uniq
  end
end

def generator_odd_abundants(from=1)
  from += 1 if from.even?
  Enumerator.new do |y|
    from.step(nil, 2) do |n|
      sum = n.proper_divisors.sum
      y << [n, sum] if sum > n
    end
  end
end

generator_odd_abundants.take(25).each{|n, sum| puts "#{n} with sum #{sum}" }
puts "\n%d with sum %#d" % generator_odd_abundants.take(1000).last
puts "\n%d with sum %#d" % generator_odd_abundants(1_000_000_000).next
