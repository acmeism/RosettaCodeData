# Fast/simple way to generate primes for small values.
# Uses P3 Prime Generator (PG) and its Prime Generator Sequence (PGS).

def prime?(n) # P3 Prime Generator primality test
  return false unless (n | 1 == 3 if n < 5) || (n % 6) | 4 == 5
  sqrt_n = Math.isqrt(n)  # For Crystal < 1.2.0 use Math.sqrt(n).to_i
  pc = typeof(n).new(5)
  while pc <= sqrt_n
    return false if n % pc == 0 || n % (pc + 2) == 0
    pc += 6
  end
  true
end

def additive_primes(n)
  primes = [2, 3]
  pc, inc = 5, 2
  while pc < n
    primes << pc if prime?(pc) && prime?(pc.digits.sum)
    pc += inc; inc ^= 0b110  # generate P3 sequence: 5 7 11 13 17 19 ...
  end
  primes # list of additive primes <= n
end

nn = 500
addprimes = additive_primes(nn)
maxdigits = addprimes.last.digits.size
addprimes.each_with_index { |n, idx| printf "%*d ", maxdigits, n; print "\n" if idx % 10 == 9 } # more efficient
#addprimes.each_with_index { |n, idx| print "%#{maxdigits}d " % n; print "\n" if idx % 10 == 9} # alternatively
puts "\n#{addprimes.size} additive primes below #{nn}."

puts

nn = 5000
addprimes = additive_primes(nn)
maxdigits = addprimes.last.digits.size
addprimes.each_with_index { |n, idx| printf "%*d ", maxdigits, n; print "\n" if idx % 10 == 9 } # more efficient
puts "\n#{addprimes.size} additive primes below #{nn}."
