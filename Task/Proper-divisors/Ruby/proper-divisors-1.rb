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

(1..10).map{|n| puts "#{n}: #{n.proper_divisors}"}

size, select = (1..20_000).group_by{|n| n.proper_divisors.size}.max
select.each do |n|
  puts "#{n} has #{size} divisors"
end
