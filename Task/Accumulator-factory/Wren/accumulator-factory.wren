var accumulator = Fn.new { |acc| Fn.new { |n| acc = acc + n } }

var x = accumulator.call(1)
x.call(5)
accumulator.call(3)
System.print(x.call(2.3))
