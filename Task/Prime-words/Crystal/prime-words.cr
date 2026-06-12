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

prime_words = File.open("unixdict.txt") do |f|
  f.each_line.select {|word|
    word.chars.map(&.ord).all?(&.prime?)
  }.to_a
end

puts prime_words.join(" ")
