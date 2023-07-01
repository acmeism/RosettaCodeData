var compose = Fn.new { |f, g| Fn.new { |x| f.call(g.call(x)) } }

var double = Fn.new { |x| 2 * x }

var addOne = Fn.new { |x| x + 1 }

System.print(compose.call(double, addOne).call(3))
