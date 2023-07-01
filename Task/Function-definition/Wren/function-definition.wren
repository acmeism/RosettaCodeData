var multiply = Fn.new { |a, b| a * b }

System.print(multiply.call(3, 7))
System.print(multiply.call("abc", 3))
System.print(multiply.call([1], 5))
System.print(multiply.call(true, false))
