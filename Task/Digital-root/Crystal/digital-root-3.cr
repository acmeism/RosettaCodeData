def digital_root_with_persistence_to_s(n : Int) : {Int32, Int32}
  n = n.abs
  persistence = 0

  until n <= 9
    persistence += 1

    digit_sum = n.to_s.chars.sum &.to_i

    n = digit_sum
  end

  {n, persistence}
end

puts digital_root_with_persistence_to_s 627615
puts digital_root_with_persistence_to_s 39390
puts digital_root_with_persistence_to_s 588225
