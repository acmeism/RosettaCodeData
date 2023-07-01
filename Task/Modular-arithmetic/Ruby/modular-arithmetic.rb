# stripped version of Andrea Fazzi's submission to Ruby Quiz #179

class Modulo
  include Comparable

  def initialize(n = 0, m = 13)
    @n, @m = n % m, m
  end

  def to_i
    @n
  end

  def <=>(other_n)
    @n <=> other_n.to_i
  end

  [:+, :-, :*, :**].each do |meth|
    define_method(meth) { |other_n| Modulo.new(@n.send(meth, other_n.to_i), @m) }
  end

  def coerce(numeric)
    [numeric, @n]
  end

end

# Demo
x, y = Modulo.new(10), Modulo.new(20)

p x > y          # true
p x == y         # false
p [x,y].sort     #[#<Modulo:0x000000012ae0f8 @n=7, @m=13>, #<Modulo:0x000000012ae148 @n=10, @m=13>]
p x + y          ##<Modulo:0x0000000117e110 @n=4, @m=13>
p 2 + y          # 9
p y + 2          ##<Modulo:0x00000000ad1d30 @n=9, @m=13>

p x**100 + x +1  ##<Modulo:0x00000000ad1998 @n=1, @m=13>
