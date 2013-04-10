def bitwise(a, b)
  puts "a and b: #{a & b}"
  puts "a or b: #{a | b}"
  puts "a xor b: #{a ^ b}"
  puts "not a: #{~a}"
  puts "a << b: #{a << b}" # left shift
  puts "a >> b: #{a >> b}" # arithmetic right shift
end
