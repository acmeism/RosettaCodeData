var a = [1, 2, 3, 4]
var b = a // now 'a' and 'b' both point to the same List data
b[3] = 5
System.print("'b' is %(b)")
System.print("'a' is %(a)") // the previous change is of course reflected in 'a' as well
var t = Object.same(a, b)   // tells you whether 'a' and 'b' refer to the same object in memory
System.print("'a' and 'b' are the same object? %(t ? "yes" : "no")")
