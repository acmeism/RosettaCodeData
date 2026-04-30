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


def jacobsthal (n)         (2_i64**n + n.bit(0))//3        end
def jacobsthal_lucas (n)    2_i64**n + (-1)**n             end
def jacobsthal_oblong (n) jacobsthal(n) * jacobsthal(n+1)  end

puts "First 30 Jacobsthal numbers:"
puts (0..29).map{|n| jacobsthal(n) }.join(" ")

puts "\nFirst 30 Jacobsthal-Lucas numbers: "
puts (0..29).map{|n| jacobsthal_lucas(n) }.join(" ")

puts "\nFirst 20 Jacobsthal-Oblong numbers: "
puts (0..19).map{|n| jacobsthal_oblong(n) }.join(" ")

puts "\nFirst 10 prime Jacobsthal numbers: "
res = (0..).each.compact_map do |i|
  j = jacobsthal(i)
  j if j.prime?
end
puts res.first(10).join(" ")
