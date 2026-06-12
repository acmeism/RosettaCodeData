require "bit_array"

def primes (max, &)
  prime = BitArray.new(max+1, true)
  (2..Math.isqrt(max)).each do |p|
    next unless prime[p]
    yield p
    ((p*p)..max).step(p).each do |c|
      prime[c] = false
    end
  end
  ((Math.isqrt(max) + 1)..max).each do |p|
    yield p if prime[p]
  end
end

def honakers (max, &)
  i = 0
  primes(max) do |p|
    i += 1
    yield p, i  if i.digits.sum == p.digits.sum
  end
end

puts "First 50 Honaker primes:"
n = 0
honakers(4100000) do |p, i|
  n += 1
  if n <= 50
    printf "%4d @ %3d     ", p, i
    puts if n % 5 == 0
  elsif n == 10000
    puts "\nThe 10000th Honaker prime: #{p} @ #{i}"
    break
  end
end
