let a = [1, 2, 3, 4, 5]
println(a.reduce(0, +)) // prints 15
println(a.reduce(1, *)) // prints 120

println(reduce(a, 0, +)) // prints 15
println(reduce(a, 1, *)) // prints 120
