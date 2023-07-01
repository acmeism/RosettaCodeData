cw = Enumerator.new do |y|
  y << a = 1.to_r
  loop { y << a = 1/(2*a.floor + 1 - a) }
end

def term_num(rat)
  num, den, res, pwr, dig = rat.numerator, rat.denominator, 0, 0, 1
  while den > 0
    num, (digit, den) = den, num.divmod(den)
    digit.times do
      res |= dig << pwr
      pwr += 1
    end
    dig ^= 1
  end
  res
end

puts  cw.take(20).join(", ")
puts  term_num  (83116/51639r)
