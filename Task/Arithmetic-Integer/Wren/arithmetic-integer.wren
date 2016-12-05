import "io" for Stdin
var a = Num.fromString(Stdin.readLine())
var b = Num.fromString(Stdin.readLine())
System.print("sum:              %(a + b)")
System.print("difference:       %(a - b)")
System.print("product:          %(a * b)")
System.print("integer quotient: %((a / b).floor)")
System.print("remainder:        %(a % b)")
