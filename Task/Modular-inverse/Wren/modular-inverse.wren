import "./big" for BigInt

var a = BigInt.new(42)
var b = BigInt.new(2017)
System.print(a.modInv(b))
