var funcs: [() -> Int] = []
for var i = 0; i < 10; i++ {
  funcs.append({ i * i })
}
println(funcs[3]()) // prints 100
