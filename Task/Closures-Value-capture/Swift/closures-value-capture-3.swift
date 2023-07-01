var funcs: [() -> Int] = []
for var i = 0; i < 10; i++ {
  funcs.append({ [i] in i * i })
}
println(funcs[3]()) // prints 9
