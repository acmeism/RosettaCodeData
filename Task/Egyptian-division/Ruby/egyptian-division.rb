def egyptian_divmod(dividend, divisor)
  table = [[1, divisor]]
  table << table.last.map{|e| e*2} while table.last.first * 2 <= dividend
  answer, accumulator = 0, 0
  table.reverse_each do |pow, double|
    if accumulator + double <= dividend
      accumulator += double
      answer += pow
    end
  end
  [answer, dividend - accumulator]
end

puts "Quotient = %s Remainder = %s" % egyptian_divmod(580, 34)
