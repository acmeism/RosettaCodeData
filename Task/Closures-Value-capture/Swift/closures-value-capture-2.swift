var funcs: [() -> Int] = []
for i in 0..<10 {
  funcs.append({ i * i })
}
println(funcs[3]()) // prints 9
