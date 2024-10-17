def humble?(i)
  return true if (i < 2)
  return humble?(i // 2) if (i % 2 == 0)
  return humble?(i // 3) if (i % 3 == 0)
  return humble?(i // 5) if (i % 5 == 0)
  return humble?(i // 7) if (i % 7 == 0)
  false
end

count, num = 0, 0_i64
digits = 10                        # max digits for humble numbers
limit  = 10_i64 ** digits          # max numbers to search through
humble = Array.new(digits + 1, 0)

while (num += 1) < limit
  if humble?(num)
    humble[num.to_s.size] += 1
    print num, " " if count < 50
    count += 1
  end
end

print "\n\nOf the first #{count} humble numbers:\n"
(1..digits).each { |num|  printf("%5d have %2d digits\n", humble[num], num) }
