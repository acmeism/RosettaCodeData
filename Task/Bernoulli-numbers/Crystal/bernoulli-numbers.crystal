require "big"

class Bernoulli
  include Iterator(Tuple(Int32, BigRational))

  def initialize
    @a = [] of BigRational
    @m = 0
  end

  def next
    @a << BigRational.new(1, @m+1)
    @m.downto(1) { |j| @a[j-1] = j*(@a[j-1] - @a[j]) }
    v = @m.odd? && @m != 1 ? BigRational.new(0, 1) : @a.first
    return {@m, v}
  ensure
    @m += 1
  end
end

b = Bernoulli.new
bn = b.first(61).to_a

max_width = bn.map { |_, v| v.numerator.to_s.size }.max
bn.reject { |i, v| v.zero? }.each do |i, v|
  puts "B(%2i) = %*i/%i" % [i, max_width, v.numerator, v.denominator]
end
