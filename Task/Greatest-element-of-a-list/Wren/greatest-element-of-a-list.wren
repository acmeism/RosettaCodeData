var max = Fn.new { |a| a.reduce { |m, x| (x > m) ? x : m } }

var a = [42, 7, -5, 11.7, 58, 22.31, 59, -18]
System.print(max.call(a))
