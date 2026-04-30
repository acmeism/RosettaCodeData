require "big"

struct Int
  def a_derivative
    if self < 0
      return -((-self).a_derivative)
    elsif self == 0 || self == 1
      return 0
    elsif self == 2
      return 1
    end
    d = self.class.new(2)
    result = self.class.new(1)
    while d * d <= self
      if self % d == 0
        q = self // d
        result = q * d.a_derivative + d * q.a_derivative
        break
      end
      d += 1
    end
    result
  end
end

(-99..100).map(&.a_derivative).each_slice(10) do |row|
  puts row.map {|n| "%4d" % n }.join(" ")
end

b10 = 10.to_big_i
(1.to_big_i .. 20).each do |n|
  puts "D(10^%2d) / 7 = %d" % {n, (b10**n).a_derivative // 7}
end
