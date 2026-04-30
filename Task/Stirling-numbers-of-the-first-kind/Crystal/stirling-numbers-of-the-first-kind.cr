require "big"

CACHE = {} of {Int32, Int32, Bool} => BigInt

def s1 (n, k, signed=false)
  return CACHE[{n, k, signed}] if CACHE.has_key?({n, k, signed})
  case
  when n == k == 0      then return 1.to_big_i
  when n > 0  && k == 0 then return 0.to_big_i
  when k > n            then return 0.to_big_i
  end
  result = if signed
             s1(n-1, k-1) - (n-1) * s1(n-1, k)
           else
             s1(n-1, k-1) + (n-1) * s1(n-1, k)
           end
  CACHE[{n, k, signed}] = result
end

puts "S1(n, k) (unsigned) for n in 1..12:"
puts "n\\k" + (1..12).map {|k| " %10d" % k }.join
(1..12).each do |n|
  puts ("%2d " % n) + (1..n).map {|k| " %10d" % s1(n, k) }.join
end
puts
puts "Maximum value of S1(n, k) (unsigned) where n = 100:"
puts (1..100).max_of {|k| s1(100, k) }
