def digital_root_with_persistence(n : Int) : {Int32, Int32}
  n = n.abs
  persistence = 0

  until n <= 9
    persistence += 1

    digit_sum = (0..(Math.log10(n).floor.to_i)).sum { |i| (n % 10**(i + 1) - n % 10**i) // 10**i }

    n = digit_sum
  end

  {n, persistence}
end

puts digital_root_with_persistence 627615
puts digital_root_with_persistence 39390
puts digital_root_with_persistence 588225
