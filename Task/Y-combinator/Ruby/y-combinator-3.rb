def y(&f)
  lambda do |g|
    f.call {|*args| g[g][*args]}
  end.tap {|g| break g[g]}
end

fac = y {|&f| lambda {|n| n < 2 ? 1 : n * f[n - 1]}}
fib = y {|&f| lambda {|n| n < 2 ? n : f[n - 1] + f[n - 2]}}

p Array.new(10) {|i| fac[i]}
# => [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]
p Array.new(10) {|i| fib[i]}
# => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
