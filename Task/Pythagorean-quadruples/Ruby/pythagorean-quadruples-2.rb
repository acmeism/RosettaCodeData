squares  = Enumerator.new{|y| (0..).each{|n| y << 2**n} }
squares5 = Enumerator.new{|y| (0..).each{|n| y << 2**n*5} }

pyth_quad = Enumerator.new do |y|
  n = squares.next
  m = squares5.next
  loop do
    if n < m
      y << n
      n = squares.next
    else
      y << m
      m = squares5.next
    end
  end
end
# this takes less than a millisecond
puts pyth_quad.take_while{|n| n <= 1000000000}.join(" ")
