def g(n, g)
  return 1 unless 1 < g && g < n-1
  (2..g).reduce(1){ |res, q| res + (q > n-g ? 0 : g(n-g, q)) }
end

(1..25).each { |n| puts (1..n).map { |g| "%4s" % g(n, g) }.join }
