var factorial // forward declaration

factorial = Fn.new { |n| (n <= 1) ? 1 : factorial.call(n-1) * n }

System.print(factorial.call(5))
