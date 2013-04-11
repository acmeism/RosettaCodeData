irb(main):001:0> cube = proc{|x| x ** 3}
=> #<Proc:0x0000020c66b878@(irb):1>
irb(main):002:0> croot = proc{|x| x ** (1.quo 3)}
=> #<Proc:0x00000201f6a6c8@(irb):2>
irb(main):003:0> compose = proc {|f,g| proc {|x| f[g[x]]}}
=> #<Proc:0x00000205e4e768@(irb):3>
irb(main):004:0> funclist = [Math.method(:sin), Math.method(:cos), cube]
=> [#<Method: Math.sin>, #<Method: Math.cos>, #<Proc:0x0000020c66b878@(irb):1>]
irb(main):005:0> invlist = [Math.method(:asin), Math.method(:acos), croot]
=> [#<Method: Math.asin>, #<Method: Math.acos>, #<Proc:0x00000201f6a6c8@(irb):2>]
irb(main):006:0> funclist.zip(invlist).map {|f, invf| compose[invf, f][0.5]}
=> [0.5, 0.4999999999999999, 0.5]
