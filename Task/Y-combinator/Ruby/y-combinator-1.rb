y = lambda do |f|
  lambda {|g| g[g]}[lambda do |g|
      f[lambda {|*args| g[g][*args]}]
    end]
end

fac = lambda{|f| lambda{|n| n < 2 ? 1 : n * f[n-1]}}
p Array.new(10) {|i| y[fac][i]}   #=> [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]

fib = lambda{|f| lambda{|n| n < 2 ? n : f[n-1] + f[n-2]}}
p Array.new(10) {|i| y[fib][i]}   #=> [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
