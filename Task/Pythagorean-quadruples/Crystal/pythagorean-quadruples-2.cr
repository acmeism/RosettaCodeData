squares  = (0..).each.map { |n| 2_u64**n }
squares5 = (0..).each.map { |n| 2_u64**n * 5 }

n = squares.next.as(Int)
m = squares5.next.as(Int)

pyth_quad = Iterator.of do
  if n < m
    value = n
    n = squares.next.as(Int)
  else
    value = m
    m = squares5.next.as(Int)
  end
  value
end

puts pyth_quad.take_while { |n| n <= 1000000000 }.join(" ")
