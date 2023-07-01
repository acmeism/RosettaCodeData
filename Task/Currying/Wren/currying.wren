var addN = Fn.new { |n| Fn.new { |x| n + x } }

var adder = addN.call(40)
System.print("The answer to life is %(adder.call(2)).")
