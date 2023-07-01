def sieve_of_sundaram(upto)
  n = (2.4 * upto * Math.log(upto)) / 2
  k = (n - 3) / 2 + 1
  bools = [true] * k
  (0..(Integer.sqrt(n) - 3) / 2 + 1).each do |i|
    p = 2*i + 3
    s = (p*p - 3) / 2
    (s..k).step(p){|j| bools[j] = false}
  end
  bools.filter_map.each_with_index {|b, i| (i + 1) * 2 + 1 if b }
end

p sieve_of_sundaram(100)
n = 1_000_000
puts "\nThe #{n}th sundaram prime is #{sieve_of_sundaram(n)[n-1]}"
