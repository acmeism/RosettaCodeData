def count_divisors(n : Int64) : Int64
  return 1_i64 if n < 2
  count = 2_i64

  i = 2
  while i <= n // 2
    count += 1 if n % i == 0
    i += 1
  end

  count
end

max_div = 0_i64
count = 0_i64

print "The first 20 anti-primes are: "

n = 1_i64
while count < 20
  d = count_divisors n

  if d > max_div
    print "#{n} "
    max_div = d
    count += 1
  end

  n += 1
end

puts ""
