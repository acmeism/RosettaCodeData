var sumSquares = Fn.new { |v| v.reduce(0) { |sum, n| sum + n * n } }

var v = [1, 2, 3, -1, -2, -3]
System.print("Vector         : %(v)")
System.print("Sum of squares : %(sumSquares.call(v))")
