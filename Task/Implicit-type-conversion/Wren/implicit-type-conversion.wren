import "./big" for BigInt

var b1 = BigInt.new(32)
var b2 = BigInt.new ("64")

var b3 = b1 + b2 + 2 + "2"
System.print(b3) // 100
