require "big"

struct Int
  def fact
    (1.bi .. self).product
  end

  def bi
    to_big_i
  end

  def over (other)
    BigRational.new(self, other)
  end
end

def slow_z3 (n)
  (1.bi .. n).sum { |k| 1.over(k**3) }
end

def markov_z3 (n)
  5.over(2) * (1.bi .. n).sum {|k|
    (-1.bi)**(k-1) * (k.fact**2).over( (k*2).fact * k**3)
  }
end

def wedeniwski_z3 (n)
  1.over(24) * (0.bi ... n).sum {|k|
    (-1.bi)**k * ( (k*2 + 1).fact**3 * (k*2).fact**3 * k.fact**3 *
                   (k**5 * 126392 + k**4 * 412708 + k**3 * 531578 + k**2 * 336367 + k * 104000 + 12463)
                 ).over( (k*3 + 2).fact * (k*4 + 3).fact**3 )
  }
end

BigFloat.default_precision = 340  # 340 bits > 100 digits

def p100 (n)
  n.to_big_f.to_s[0..101]
end

puts "Actual:                 1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581"
puts "Sum reciprocals (1000): #{p100(slow_z3(1000))}"
puts "Markov (158):           #{p100(markov_z3(158))}"
puts "Wedeniwski (20):        #{p100(wedeniwski_z3(20))}"
