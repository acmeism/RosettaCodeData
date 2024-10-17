require "big"

def e(precision)
  y = BigDecimal.new(10.to_big_i ** precision, precision)
  d = y
  i = 1

  while true
    d = (d / i).scale_to(y)
    y2 = y + d
    return y if y2 == y
    y = y2
    i += 1
  end
end

balance = e(50) - 1
1.upto(25) { |y| balance = (balance * y) - 1 }
puts "Bank balance after 25 years = #{balance.to_f}"
