def perf(n)
  n == (1...n).select {|i| n % i == 0}.inject(:+)
end
