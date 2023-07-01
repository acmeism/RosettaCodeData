function stdev()
  local sum, sumsq, k = 0,0,0
  return function(n)
    sum, sumsq, k = sum + n, sumsq + n^2, k+1
    return math.sqrt((sumsq / k) - (sum/k)^2)
  end
end

ldev = stdev()
for i, v in ipairs{2,4,4,4,5,5,7,9} do
  print(ldev(v))
end
