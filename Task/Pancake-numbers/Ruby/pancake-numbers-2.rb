def pancake(n)
  gap = 2
  pg = 1
  sum = 2
  adj = -1
  while sum < n
    adj = adj + 1
    t = pg
    pg = gap
    gap = gap + t
    sum = sum + gap
  end
  return n + adj
end

for i in 0..3
  for j in 1..5
    n = i * 5 + j
    print "p(%2d) = %2d  " % [n, pancake(n)]
  end
  print "\n"
end
