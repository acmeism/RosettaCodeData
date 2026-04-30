struct Int
  def prime? # P3 Prime Generator primality test
    return self | 1 == 3 if self < 5
    return false if self.gcd(6) != 1
    sqrt_n = Math.isqrt(self)
    pc = typeof(self).new(5)
    while pc <= sqrt_n
      return false if self % pc == 0 || self % (pc + 2) == 0
      pc += 6
    end
    true
  end
end

(3i64..).each.compact_map {|p|
  if p.prime?
    w = (2i64**p + 1) // 3
    { p, w }  if w.prime?
  end
}.first(10).each do |p, w|
  printf "%3d: %d\n", p, w
end
