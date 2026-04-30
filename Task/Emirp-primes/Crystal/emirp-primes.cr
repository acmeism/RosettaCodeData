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

  def emirp?
    return false unless prime?
    # reverse
    n = self.abs
    m = typeof(self).new(0)
    while n > 0
      m = m*10 + n%10
      n //= 10
    end
    m.prime?
  end
end

print "First 20 emirps:\n  "
p (1..).each.select(&.emirp?).first(20).to_a
print "Emirps between 7,700 and 8,000:\n  "
p (7700..8000).select &.emirp?
print "The 10,000th emirp: "
puts (1..).each.select(&.emirp?).skip(9999).next
