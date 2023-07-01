func addN(n:Int)(_ x:Int) -> Int { return x + n }

var add2 = addN(2)
println(add2) // (Function)
println(add2(7)) // 9
