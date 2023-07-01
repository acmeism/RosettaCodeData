def humble?(i)
  while i % 2 == 0; i /= 2 end
  while i % 3 == 0; i /= 3 end
  while i % 5 == 0; i /= 5 end
  while i % 7 == 0; i /= 7 end
  i == 1
end

count, num = 0, 0
digits = 10                        # max digits for humble numbers
limit  = 10 ** digits              # max numbers to search through
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
