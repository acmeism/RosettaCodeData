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

  def magnanimous?
    n = self.abs
    i = typeof(self).new(10)
    loop do
      a, b = n.divmod(i)
      break if a.zero?
      return false unless (a + b).prime?
      i *= 10
    end
    true
  end
end

def magnaseq
  (0..).each.select(&.magnanimous?)
end

print "First 45 magnanimous numbers:\n  "
p magnaseq.first(45).to_a
print "From 241st to 250th: "
puts magnaseq.skip(240).first(10).to_a
print "From 391st to 400th: "
puts magnaseq.skip(390).first(10).to_a
