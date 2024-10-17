def semiprime(n)
  `factor #{n}`.split(' ').size == 3
end
n = 0xffffffffffffffff_u64 # 2**64 - 1 = 18446744073709551615
(n-50..n).each { |n| puts "#{n} -> #{semiprime(n)}" }
