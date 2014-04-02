def perf(n)
  sum = 0
  for i in 1...n
    sum += i  if n % i == 0
  end
  sum == n
end
