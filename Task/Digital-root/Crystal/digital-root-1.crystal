def digital_root(n : Int, base = 10) : Int
  max_single_digit = base - 1
  n = n.abs
  if n > max_single_digit
    n = 1 + (n - 1) % max_single_digit
  end
  n
end

puts digital_root 627615
puts digital_root 39390
puts digital_root 588225
puts digital_root 7, base: 3
