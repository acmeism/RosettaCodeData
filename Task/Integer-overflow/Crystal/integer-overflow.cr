macro try (expr)
  printf "%-*s # => ", padding, {{expr.stringify}}
  begin
    puts {{expr}}
  rescue ex
    puts "Exception: #{ex.message}"
  end
end

padding = 25
puts "Result does not fit into a 32-bit signed integer:"
try -(-2147483647-1)
try 2000000000 + 2000000000
try -2147483647 - 2147483647
try 46341 * 46341
try (-2147483647-1) // -1

padding = 52
puts "\nResult does not fit into a 64-bit signed integer:"
try -(-9223372036854775807 - 1)
try 5000000000000000000 + 5000000000000000000
try -9223372036854775807 - 9223372036854775807
try 3037000500 * 3037000500
try (-9223372036854775807 - 1) // -1

padding = 32
puts "\nResult does not fit into a 32-bit unsigned integer:"
try -4294967295.to_u32
try 3000000000_u32 + 3000000000_u32
try 2147483647_u32 - 4294967295_u32
try 65537_u32 * 65537_u32

padding = 52
puts "\nResult that does not fit into a 64-bit unsigned integer:"
try -18446744073709551615_i128.to_u64
try 10000000000000000000_u64 + 10000000000000000000_u64
try 9223372036854775807_u64 - 18446744073709551615_u64
try 4294967296_u64 * 4294967296_64
