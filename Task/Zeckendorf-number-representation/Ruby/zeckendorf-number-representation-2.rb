def zeckendorf(n)
  return 0 if n.zero?
  fib = [1,2]
  fib << fib[-2] + fib[-1] while fib[-1] < n
  dig = ""
  fib.reverse_each do |f|
    if f <= n
      dig, n = dig + "1", n - f
    else
      dig += "0"
    end
  end
  dig.to_i
end

for i in 0..20
  puts '%3d: %8d' % [i, zeckendorf(i)]
end
