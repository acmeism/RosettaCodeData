struct Int
  def to_frac
    Frac.new self
  end

  def over (den)
    Frac.new self, den
  end
end

struct Frac
  include Comparable(Number)

  getter num : Int64
  getter den : Int64

  def initialize (num : Int, den : Int)
    raise "denominator can't be 0" if den.zero?
    if num.zero?
      @num, @den = 0_i64, 1_i64
    else
      sign = num.sign * den.sign
      num, den = num.to_i64.abs, den.to_i64.abs
      gcd = num.gcd(den)
      @num = (num // gcd) * sign
      @den = (den // gcd)
    end
  end

  def initialize (num : Int)
    initialize(num, 1)
  end

  def to_i
    @num // @den
  end

  def to_f
    @num / @den
  end

  def whole?
    @den == 1
  end

  def to_frac
    self
  end

  def inv
    self.class.new @den, @num
  end

  def sign
    @num.sign
  end

  def -
    self.class.new -@num, @den
  end

  def abs
    self.class.new @num.abs, @den
  end

  def + (other)
    other = other.to_frac
    lcm = @den.lcm(other.den)
    self.class.new(@num * lcm // @den + other.num * lcm // other.den, lcm)
  end

  def - (other)
    self + -other
  end

  def * (other)
    other = other.to_frac
    self.class.new @num * other.num, @den * other.den
  end

  def / (other)
    self * other.to_frac.inv
  end

  def // (other)
    other = other.to_frac
    self.class.new((@num * other.den) // (@den * other.num))
  end

  def % (other)
    other = other.to_frac
    self.class.new((@num * other.den) % (@den * other.num), @den * other.den)
  end

  def <=> (other)
    self.to_f <=> other.to_f
  end
end

(2_i64 .. 2_i64**19).each do |candidate|
  sum = 1.over candidate
  (2_i64 .. Math.isqrt(candidate)).each do |factor|
    if candidate % factor == 0
      sum += 1.over(factor) + 1.over(candidate // factor)
    end
  end
  if sum.whole?
    puts "Sum of recipr. factors of %6d = %s exactly%s" % { candidate, sum.num, sum == 1 ? " perfect!" : "" }
  end
end
