irb(main):001:0> Y = lambda do |f|
irb(main):002:1*   lambda {|g| g[g]}[lambda do |g|
irb(main):003:3*                       f[lambda {|*args| g[g][*args]}]
irb(main):004:3>                     end]
irb(main):005:1> end
=> #<Proc:0x00000204f5e6e0@(irb):1 (lambda)>
irb(main):006:0> Fac = lambda{|f| lambda{|n| n < 2 ? 1 : n * f[n-1]}}
=> #<Proc:0x00000202a88aa0@(irb):6 (lambda)>
irb(main):007:0> Array.new(10) {|i| Y[Fac][i]}
=> [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]
irb(main):008:0> Fib = lambda{|f| lambda{|n| n < 2 ? n : f[n-1] + f[n-2]}}
=> #<Proc:0x00000201a968b8@(irb):8 (lambda)>
irb(main):009:0> Array.new(10) {|i| Y[Fib][i]}
=> [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
