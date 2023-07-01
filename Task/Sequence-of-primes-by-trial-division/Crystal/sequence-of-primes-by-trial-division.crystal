require "big"

def primep5?(n)                          # P5 Prime Generator primality test
  # P5 = 30*k + {7,11,13,17,19,23,29,31} # P5 primes candidates sequence
  n = n.to_big_i
  return [2, 3, 5].includes?(n) if n < 7 # for small and negative values
  return false if n.gcd(30) != 1         # 4/15 (8/30) of integers are P5 pc
  p = typeof(n).new(7)                   # first P5 sequence value
  until p*p > n
    return false if                      # if n is composite
      n % (p)    == 0 || n % (p+4)  == 0 || n % (p+6)  == 0 || n % (p+10) == 0 ||
      n % (p+12) == 0 || n % (p+16) == 0 || n % (p+22) == 0 || n % (p+24) == 0
      p += 30  # first prime candidate for next kth residues group
  end
  true
end

# Create sequence of primes from 1_000_000_001 to 1_000_000_201
n = 1_000_000_001; n.step(to: n+200, by: 2) { |p| puts p if primep5?(p) }
