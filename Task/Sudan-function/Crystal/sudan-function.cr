def sudan (n, x : UInt64, y : UInt64)
  if n == 0
    x + y
  elsif y == 0
    x
  else
    s = sudan(n, x, y-1)
    sudan(n-1, s, s + y)
  end
end

[{0, 0, 0}, {1, 1, 1}, {2, 1, 1}, {2, 2, 1}, {2, 2, 2}, {3, 1, 1}].each do |n, x, y|
  puts "sudan #{n} (#{x}, #{y}) = #{sudan(n, x.to_u64, y.to_u64)}"
end
