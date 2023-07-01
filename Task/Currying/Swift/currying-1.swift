func addN(n:Int)->Int->Int { return {$0 + n} }

var add2 = addN(2)
println(add2) // (Function)
println(add2(7)) // 9
