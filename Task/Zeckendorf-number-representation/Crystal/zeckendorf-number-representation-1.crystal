def zeckendorf(n)
  return 0 if n.zero?
  fib = [1, 2]
  while fib[-1] < n; fib << fib[-2] + fib[-1] end
  digit = ""
  fib.reverse_each do |f|
    if f <= n
      digit, n = digit + "1", n - f
    else
      digit += "0"
    end
  end
  digit.to_i
end

(0..20).each { |i| puts "%3d: %8d" % [i, zeckendorf(i)] }
