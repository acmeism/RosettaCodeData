def humble(digits)
  h = [1]
  x2, x3, x5, x7 = 2, 3, 5, 7
  i, j, k, l = 0, 0, 0, 0
  n = 0
  while n += 1                            # ruby => 2.6: (1..).each do |n|
    x = [x2, x3, x5, x7].min
    break if x.to_s.size > digits
    h[n] = x
    x2 = 2 * h[i += 1] if x2 == h[n]
    x3 = 3 * h[j += 1] if x3 == h[n]
    x5 = 5 * h[k += 1] if x5 == h[n]
    x7 = 7 * h[l += 1] if x7 == h[n]
  end
  h
end

digits = 50                               # max digits for humble numbers
h = humble(digits)                        # humble numbers <= digits size
count  = h.size                           # the total humble numbers count
#counts = h.map { |n| n.to_s.size }.tally # hash of digits counts 1..digits: Ruby => 2.7
counts = h.map { |n| n.to_s.size }.group_by(&:itself).transform_values(&:size) # Ruby => 2.4
print "First 50 Humble Numbers: \n"; (0...50).each { |i| print "#{h[i]} " }
print "\n\nOf the first #{count} humble numbers:\n"
(1..digits).each { |num|  printf("%6d have %2d digits\n", counts[num], num) }
