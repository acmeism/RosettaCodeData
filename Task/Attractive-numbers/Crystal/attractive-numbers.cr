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

  def attractive?
    n = self
    sum = 0
    primes.each do |prime|
      loop do
        next_n, mod = n.divmod(prime)
        break unless mod == 0
        sum += 1
        n = next_n
      end
      break if n <= prime
    end
    sum += 1 if n > 1
    sum.prime?
  end
end

def primes
  [2].each.chain((3..).step(by: 2).select &.prime?)
end

(1..120).select(&.attractive?).each_slice(15) do |row|
  puts row.map {|n| " %3d" % n }.join
end
