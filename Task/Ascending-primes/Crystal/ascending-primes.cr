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

digits = [1,2,3,4,5,6,7,8,9]
res = (1..digits.size).flat_map do |n|
   digits.each_combination(n).compact_map do |set|
      candidate = set.join.to_i
      candidate if candidate.prime?
   end.to_a.sort
 end

 puts res
