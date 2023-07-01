var sumSeries = Fn.new { |n| (1..n).reduce(0) { |sum, i| sum + 1/(i*i) } }

System.print("s(1000) = %(sumSeries.call(1000))")
System.print("zeta(2) = %(Num.pi*Num.pi/6)")
