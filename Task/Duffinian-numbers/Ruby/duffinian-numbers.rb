require "prime"

class Integer

  def proper_divisors(prim_div = prime_division)
    return [] if self == 1
    primes = prim_div.flat_map{|prime, freq| [prime] * freq}
    (1...primes.size).each_with_object([1]) do |n, res|
      primes.combination(n).map{|combi| res << combi.inject(:*)}
    end.flatten.uniq
  end

  def duffinian?
    pd = prime_division
    return false if pd.sum(&:last) < 2
    gcd(proper_divisors(pd).sum + self) == 1
  end

end

n = 50
puts "The first #{n} Duffinian numbers:"
(1..).lazy.select(&:duffinian?).first(n).each_slice(10) do |slice|
  puts "%4d" * slice.size % slice
end

puts "\nThe first #{n} Duffinian triplets:"
(1..).each_cons(3).lazy.select{|slice| slice.all?(&:duffinian?)}.first(n).each do |group|
  puts "%8d" * group.size % group
end
