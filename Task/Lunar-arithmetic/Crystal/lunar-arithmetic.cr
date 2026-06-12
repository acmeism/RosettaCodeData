struct LunarNumber
  include Comparable(LunarNumber)

  getter n

  def initialize (@n : UInt64)
  end

  def + (other : LunarNumber)
    n, m = self.n, other.n
    result = 0_u64
    pos = 1_u64
    while n != 0 || m != 0
      result = result + Math.max(n % 10, m % 10) * pos
      n //= 10; m //= 10; pos *= 10
    end
    result.to_lunar
  end

  def * (other : LunarNumber)
    result : UInt64 = 0
    m = other.n
    pos = 1_u64
    while m != 0
      n = self.n
      pos_n = 1_u64
      partial = 0_u64
      while n != 0
        partial = partial + Math.min(n % 10, m % 10) * pos_n
        n //= 10; pos_n *= 10
      end
      result = (result.to_lunar + (partial * pos).to_lunar).n
      m //= 10; pos *= 10
    end
    result.to_lunar
  end

  def squared
    self * self
  end

  def <=> (other : LunarNumber)
    self.n <=> other.n
  end

  def to_s (io)
    io << '☾'
    @n.to_s io
    io << '☽'
  end
end

struct Int
  def to_lunar
    LunarNumber.new self.to_u64
  end
end

# task:
[[976, 348], [23, 321], [232, 35], [123, 32192, 415, 8]].each do |ns|
  numbers = ns.map(&.to_lunar)
  puts " Add: #{numbers.join(" + ")} = #{numbers.reduce {|a, b| a + b }}"
  puts "Mult: #{numbers.join(" × ")} = #{numbers.reduce {|a, b| a * b }}"
  puts
end
distinct_evens = Set(LunarNumber).new
(0_u64..).each do |i|
  distinct_evens.add(i.to_lunar * 2.to_lunar)
  break if distinct_evens.size == 20
end
puts "First 20 distinct even numbers: #{distinct_evens.to_a.sort!.join(' ')}"
puts
puts "First 20 square numbers: #{(0...20).map {|n| n.to_lunar * n.to_lunar }.join(' ')}"
puts
puts "First 20 factorial numbers: #{(1..20).map(&.to_lunar).accumulate{|a,b| a*b}.join(' ')}"
puts
puts "First number whose square is smaller than the previous one: " +
     (1..).find! {|n| n.to_lunar.squared < (n-1).to_lunar.squared}.to_lunar.to_s
