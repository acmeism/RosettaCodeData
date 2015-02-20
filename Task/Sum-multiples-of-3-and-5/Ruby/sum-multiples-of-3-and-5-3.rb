def sumMul(n, f)
  n1 = (n - 1) / f
  f * n1 * (n1 + 1) / 2
end

def sum35(n)
  sumMul(n, 3) + sumMul(n, 5) - sumMul(n, 15)
end

for i in 1..20
  puts "%2d:%22d %s" % [i, 10**i, sum35(10**i)]
end
