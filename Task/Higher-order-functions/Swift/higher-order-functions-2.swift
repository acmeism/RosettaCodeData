func func3<T>(f: (Int,Int)->T) -> T { return f(1, 2) }
println(func3 {(x, y) in x + y}) // prints "3"
