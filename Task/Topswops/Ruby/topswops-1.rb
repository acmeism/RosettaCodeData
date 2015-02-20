def f1(a)
  i = 0
  while (a0 = a[0]) > 1
    a[0...a0] = a[0...a0].reverse
    i += 1
  end
  i
end

def fannkuch(n)
  [*1..n].permutation.map{|a| f1(a)}.max
end

for n in 1..10
  puts "%2d : %d" % [n, fannkuch(n)]
end
