require 'prime'

class Integer
  def proper_divisors
    return [] if self == 1
    primes = prime_division.flat_map{|prime, freq| [prime] * freq}
    (1...primes.size).each_with_object([1]) do |n, res|
      primes.combination(n).map{|combi| res << combi.inject(:*)}
    end.flatten.uniq.sort
  end
end

super_poulets = (1..).lazy.select do |n|
  n.prime? == false  &&
  2.pow(n-1, n) == 1 && # modular exponentiation
  n.proper_divisors[1..].all?{|d| 2.pow(d, d) == 2} # again
end

m = 20
puts "First #{m} super-Poulet numbers:\n#{super_poulets.first(m).join(-", ") }"

[1_000_000, 10_000_000].each do |m|
  puts "\nValue and index of first super-Poulet number greater than #{m}:"
  puts "%d is #%d" % super_poulets.with_index(1).detect{|n, i| n > m }
end
