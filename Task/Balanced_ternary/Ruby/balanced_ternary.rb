class BalancedTernary
  def initialize(str = "")
    if str !~ /^[-+0]+$/
      raise ArgumentError, "invalid BalancedTernary number: #{str}"
    end
    @digits = trim0(str)
  end

  def self.from_int(value)
    n = value
    digits = ""
    while n != 0
      quo, rem = n.divmod(3)
      case rem
      when 0
        digits = "0" + digits
        n = quo
      when 1
        digits = "+" + digits
        n = quo
      when 2
        digits = "-" + digits
        n = quo + 1
      end
    end
    new(digits)
  end

  def to_int
    @digits.chars.inject(0) do |sum, char|
      sum *= 3
      case char
      when "+"
        sum += 1
      when "-"
        sum -= 1
      end
      sum
    end
  end
  alias :to_i :to_int

  def to_s
    @digits
  end
  alias :inspect :to_s

  ADDITION_TABLE = {
    "-" => {"-" => ["-","+"], "0" => ["0","-"], "+" => ["0","0"]},
    "0" => {"-" => ["0","-"], "0" => ["0","0"], "+" => ["0","+"]},
    "+" => {"-" => ["0","0"], "0" => ["0","+"], "+" => ["+","-"]},
  }

  def +(other)
    maxl = [to_s, other.to_s].collect {|s| s.length}.max
    a = pad0(to_s, maxl)
    b = pad0(other.to_s, maxl)
    carry = "0"
    sum = a.reverse.chars.zip( b.reverse.chars ).inject("") do |sum, (c1, c2)|
      carry1, digit1 = ADDITION_TABLE[c1][c2]
      carry2, digit2 = ADDITION_TABLE[carry][digit1]
      sum = digit2 + sum
      carry = ADDITION_TABLE[carry1][carry2][1]
      sum
    end
    self.class.new(carry + sum)
  end

  MULTIPLICATION_TABLE = {
    "-" => "+0-",
    "0" => "000",
    "+" => "-0+",
  }

  def *(other)
    product = self.class.new("0")
    other.to_s.each_char do |bdigit|
      row = to_s.tr("-0+", MULTIPLICATION_TABLE[bdigit])
      product += self.class.new(row)
      product << 1
    end
    product >> 1
  end

  # negation
  def -@()
    self * BalancedTernary.new("-")
  end

  # subtraction
  def -(other)
    self + (-other)
  end

  # shift left
  def <<(count)
    @digits = trim0(@digits + "0"*count)
    self
  end

  # shift right
  def >>(count)
    @digits[-count..-1] = "" if count > 0
    @digits = trim0(@digits)
    self
  end

  private

  def trim0(str)
    str = str.sub(/^0+/, "")
    str = "0" if str.empty?
    str
  end

  def pad0(str, len)
    str.rjust(len, "0")
  end
end

a = BalancedTernary.new("+-0++0+")
b = BalancedTernary.from_int(-436)
c = BalancedTernary.new("+-++-")
calc = a * (b - c)
puts "%s\t%d\t%s\n" % ['a', a.to_i, a]
puts "%s\t%d\t%s\n" % ['b', b.to_i, b]
puts "%s\t%d\t%s\n" % ['c', c.to_i, c]
puts "%s\t%d\t%s\n" % ['a*(b-c)', calc.to_i, calc]
