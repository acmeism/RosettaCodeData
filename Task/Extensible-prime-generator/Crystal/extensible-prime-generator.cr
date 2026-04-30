struct Int
  # from [[Primality by trial division#Crystal]], slightly adjusted
  def prime?
    n = self.abs
    return n == 2 || n == 3 || n == 5 if n < 7
    return false if n.gcd(30) != 1
    p = typeof(n).new(7)
    √n = Math.isqrt(n)
    until p > √n
      return false if
        n % (p)    == 0 || n % (p+4)  == 0 || n % (p+6)  == 0 || n % (p+10) == 0 ||
        n % (p+12) == 0 || n % (p+16) == 0 || n % (p+22) == 0 || n % (p+24) == 0
      p += 30
    end
    true
  end
end

print "First 20 primes:\n  "
p (1..).each.select(&.prime?).first(20).to_a
print "Primes between 100 and 150:\n  "
p (100..150).select(&.prime?)
print "Number of primes between 7,700 and 8,000: "
puts (7700..8000).count &.prime?
print "The 10,000th prime: "
puts (1..).each.select(&.prime?).skip(9999).next
