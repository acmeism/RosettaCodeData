var a = [1, 2, 3, 4, 5]
var sum   = a.reduce { |acc, i| acc + i }
var prod  = a.reduce { |acc, i| acc * i }
var sumSq = a.reduce { |acc, i| acc + i*i }
System.print(a)
System.print("Sum is %(sum)")
System.print("Product is %(prod)")
System.print("Sum of squares is %(sumSq)")
